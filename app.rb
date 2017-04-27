require 'sinatra'
enable :sessions

def deal(shoe)
  hand = []
  2.times do
    hand << shoe.shift
  end
  return hand
end

def create_shoe
  rank_hash = {"2":  2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "10": 10, "J": 10, "Q": 10, "K": 10, "A": 11}
  suit_arr = [:H, :D, :C, :S]
  shoe_cards = []
  1.times do
    suit_arr.each do |suit_sym|
      rank_hash.each do |rank, value|
        shoe_cards << Card.new(rank, suit_sym, value)
      end
    end
  end
  shoe_ready = shoe_cards.shuffle
  return shoe_ready
end #create_shoe method

def bank
  480
end

def render(dealer_reveal, num_players, ai)
  puts @shoe.length
  if dealer_reveal
    puts "Dealer total:  #{@dealer.total}."
    puts "Dealer cards:  #{dealer_hand}"
  else
    puts "Dealer total showing:  #{dealer_total_showing}."
    puts "Dealer cards:  #{dealer_showing}"
  end
  num_players.times do |x|
    puts "#{@players[x].name}'s bet: #{@players[x].bet}, chips: #{@players[x].chips},  total: #{@players[x].total}."
    if @players[x].insurance_bet > 0
      puts "#{@players[x].name}'s' insurance bet: #{@players[x].insurance_bet}."
    end
    puts "#{@players[x].name}'s' cards:  #{player_hand(@players[x].hand)}"
    if !@players[x].split_hand.empty?
      puts "#{@players[x].name}'s' split cards:  #{player_hand(@players[x].split_hand)}"
    end
  end
  if ai
    puts "#{@comp.name}'s bet:  #{@comp.bet}, chips:  #{@comp.chips}, total:  #{@comp.total}."
    puts "#{@comp.name}'s cards:  #{player_hand(@comp.hand)}"
    if !@comp.split_hand.empty?
      puts "#{@comp.name}'s' split cards:  #{player_hand(@comp.split_hand)}"
    end
  end
end #render method

def dealer_hand #Helper for render
  dealer_hand_string = ""
  @dealer.hand.each do |x|
    dealer_hand_string += "#{x.name}  "
  end
  return dealer_hand_string
end

def dealer_total_showing #Helper for render
  tot = 0
  if !@dealer.hand.nil?
    @dealer.hand.each do |dealer_card|
      if !dealer_card.nil?
        tot += dealer_card.value
      else
        tot += 0
      end
    end
    face_down = @dealer.hand[1]
    if !face_down.nil?
      tot -= face_down.value
    else
      tot -= 0
    end
  else
    tot = 0
  end
  return tot
end #dealer_total_showing method

def dealer_showing #Helper for render
  if !@dealer.hand[0].nil?
    "#{@dealer.hand[0].name}  ??"
  else
     "-- --"
  end
end # dealer_showing method

def player_hand(hand)
  if !hand[0].nil?
    player_hand_string = ""
    hand.each do |x|
      player_hand_string += "#{x.name}  "
    end
    return player_hand_string
  else
    "-- --"
  end
end  # player_hand method

class Card
  attr_accessor :value, :rank, :suit, :name
  def initialize(rank, suit_sym, value)
    @rank = rank
    @suit = suit_sym
    @value = value
    @name = "#{rank}#{suit}"
  end
end

get '/' do
  session["shoe"] = create_shoe
  session["turn"] = 0
  erb :index
end

post '/blackjack' do
  shoe = session["shoe"]
  session["dealer_hand"] = deal(shoe)
  session["num_players"] = params[:num_players].to_i
  session["num_players"].times do |x|
    session["player#{x}_hand"] = deal(shoe)
    session["player#{x}_bank"] = bank
  end
  session["ai"] = params[:ai]
  if session["ai"]
    session["ai_hand"] = deal(shoe)
    session["ai_bank"] = bank
  end
  erb :blackjack
end

post '/bet' do
  session["player#{session["turn"]}_bet"] = params[:bet]
  session["turn"] += 1
  if session["turn"] == session["num_players"]
    erb :bet
  else
    erb :blackjack
  end
end
