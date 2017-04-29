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

def update_chips(chips, op, amount)
  if op == "subtract"
    updated_chips = chips - amount
  else
    updated_chips = chips + amount
  end
  return updated_chips
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

def validate_bet(chips, bet)
  if bet <= chips
    chips =  update_chips(chips, "subtract", bet)
  else
    bet = bank
    chips =  update_chips(chips, "subtract", bet)
  end
  return chips
end

def options_set_up_validations
  session["need_insurance"] = session["dealer"].total_showing == 11
  session["player_blackjack"] = player_blackjack
  session["player_split"] = player_split
end

def player_blackjack
  bj = false
  session["num_players"].times do |player|
    if (session["player#{player}"].total == 21) && (session["player#{player}"].hand.length == 2)
      return true
    end
  end
  if (session["ai"].total == 21) && (session["ai"].hand.length == 2)
    return true
  end
  return bj
end

def player_split
  split = false
  session["num_players"].times do |player|
    if (session["player#{player}"].chips >= session["player#{player}"].bet) && (session["player#{player}"].hand[0].rank == session["player#{player}"].hand[1].rank)
      return true
    end
  end
  if (session["ai"].chips >= session["ai"].bet) && (session["ai"].hand[0].rank == session["ai"].hand[1].rank)
  end
  return split
end

def player_double
  double = false
  session["num_players"].times do |player|
    if (session["player#{player}"].chips >= session["player#{player}"].bet)
      return true
    end
  end
  if (session["ai"].chips >= session["ai"].bet)
    return true
  end
  return double
end

def bust(player)
  return player.total > 21
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
  def initialize(name, shoe)
    @name = name
    @chips = 1000
    @hand = deal(shoe)
    @total = player_total(@hand)
    @bet = 0
    @insurance_bet = 0
    @split_hand = []
    @split_total = 0
    @split_bet = 0
  end
end #Player class

class Dealer
  attr_accessor :name, :hand, :total, :total_showing, :reveal
  def initialize(shoe)
    @name = "Conrad"
    @reveal = false
    @hand = deal(shoe)
    @total = 0
    @total_showing = dealer_total_showing(@hand, @reveal)
  end
end #Dealer Class

get '/' do
  erb :index
end

post '/init_players' do
  session["shoe"] = create_shoe
  session["dealer"] = Dealer.new(session["shoe"])
  session["num_players"] = params[:num_players].to_i
  session["ai"] = params[:ai]
  if session["ai"]
    session["ai"] = Player.new("Ben", session["shoe"])
  end
  session["turn"] = 0
  erb :names
end

post '/save_names' do
  if params[:name] != nil
    session["player#{session["turn"]}"] = Player.new(params[:name], session["shoe"])
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
  validate_bet(session["player#{session["turn"]}"].chips, session["player#{session["turn"]}"].bet)
  session["turn"] += 1
  if session["turn"] == session["num_players"]
    validate_bet(session["ai"].chips, 20) if session["ai"]
    options_set_up_validations
    erb :blackjack
  else
    erb :bet
  end
end
