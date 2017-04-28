require 'sinatra'
enable :sessions

def deal
  hand = []
  2.times do
    hand << session["shoe"].shift
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

def update_bank(bank, op, amount)
  if op == "subtract"
    updated_bank = bank - amount
  else
    updated_bank = bank + amount
  end
  return updated_bank
end

def ai_bet
  bet = 0
  if session["dealer_total_showing"] >= 20
    bet = 10
  elsif session["ai_total"] >= 20
    bet = 50
  else
    bet = 20
  end
  return bet
end

def player_total(hand)
  tot = 0
  hand.each do |card|
    tot += card.value
  end
  return tot
end

def dealer_total_showing(hand, reveal)
  tot = 0
  if reveal
    hand.each do |card|
      tot += card.value
    end
  else
    tot = hand[0].value
  end
  return tot
end

def valid_bet(bank, bet)
  return bet <= bank
end

class Card
  attr_accessor :value, :rank, :suit, :name
  def initialize(rank, suit_sym, value)
    @rank = rank
    @suit = suit_sym
    @value = value
    @name = "#{rank}#{suit}"
  end
end #end Card class

class Player
  attr_accessor :name, :chips, :hand, :bet, :insurance_bet, :split_hand,  :split_total, :split_bet, :total
  def initialize(name)
    @name = name
    @chips = 1000
    @hand = []
    @total = 0
    @bet = 0
    @insurance_bet = 0
    @split_hand = []
    @split_total = 0
    @split_bet = 0
  end

  def blackjack(player)
    return (player.total == 21) && (@hand.length == 2)
  end

  def bust(player)
    return player.total > 21
  end
end #Player class

class Dealer
  attr_accessor :name, :hand, :total, :total_showing, :reveal
  def initialize
    @name = "Conrad"
    @reveal = false
    @hand = []
    @total = 0
    @total_showing = 0
  end

  # def blackjack(player)
  #   return (player.total == 21) && (@hand.length == 2)
  # end
  #
  # def bust(player)
  #   return player.total > 21
  # end
end #Dealer Class

get '/' do
  erb :index
end

post '/init_players' do
  session["dealer"] = Dealer.new
  session["num_players"] = params[:num_players].to_i
  session["ai"] = params[:ai]
  if session["ai"]
    session["ai"] = Player.new("Ben")
  end
  session["turn"] = 0
  erb :names
end

post '/save_names' do
  if params[:name] != nil
    session["player#{session["turn"]}"] = Player.new(params[:name])
  end
  session["turn"] += 1
  if session["turn"] < session["num_players"]
    erb :names
  else
    session["turn"] = 0
    erb :bet
  end
end

post '/place_bet' do
  session["player#{session["turn"]}"].bet = params[:bet].to_i
  if valid_bet(session["player#{session["turn"]}"].chips, session["player#{session["turn"]}"].bet)
    session["player#{session["turn"]}"].chips =  update_bank(session["player#{session["turn"]}"].chips, "subtract", session["player#{session["turn"]}"].bet)
  else
    session["player#{session["turn"]}"].bet = session["player#{session["turn"]}"].chips
    session["player#{session["turn"]}"].chips =  update_bank(session["player#{session["turn"]}"].chips, "subtract", session["player#{session["turn"]}"].bet)
  end
  session["turn"] += 1
  if session["turn"] == session["num_players"]
    #shoe set-up
    session["shoe"] = create_shoe
    #dealer set-up
    session["dealer"].hand = deal
    session["dealer"].total_showing = dealer_total_showing(session["dealer"].hand, false)
    #player set-up
    session["num_players"].times do |x|
      session["player#{x}"].hand = deal
      session["player#{x}"].total = player_total(session["player#{x}"].hand)
    end
    #ai set-up
    if session["ai"]
      session["ai"].bet = 20
      session["ai"].chips = update_bank(session["ai"].chips, "subtract", session["ai"].bet)
      session["ai"].hand = deal
      session["ai"].total = player_total(session["ai"].hand)
    end
    erb :blackjack
  else
    erb :bet
  end
end


post '/blackjack' do
  erb :blackjack
end
