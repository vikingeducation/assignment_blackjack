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
  # shoe_ready = shoe_cards.shuffle
  shoe_ready = shoe_cards.unshift(Card.new("6", :H, 6))
  shoe_ready = shoe_cards.unshift(Card.new("6", :C, 6))
  shoe_ready = shoe_cards.unshift(Card.new("6", :D, 6))
  shoe_ready = shoe_cards.unshift(Card.new("4", :D, 4))
  shoe_ready = shoe_cards.unshift(Card.new("4", :H, 4))
  shoe_ready = shoe_cards.unshift(Card.new("5", :H, 5))
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

def options_set_up_validations
  session["turn"] = 0
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

def settle_dealer_blackjack
  session["num_players"].times do |player|
    session["player#{player}"].chips = update_chips(session["player#{player}"].chips, "add", session["player#{player}"].insurance_bet * 2) if session["player#{player}"].insurance_bet > 0
    session["player#{player}"].chips = update_chips(session["player#{player}"].chips, "add", session["player#{player}"].bet) if session["player#{player}"].total == 21
  end
  session["ai"].chips = update_chips(session["ai"].chips, "add", session["ai"].insurance_bet * 2) if session["ai"].insurance_bet > 0
  session["ai"].chips = update_chips(session["ai"].chips, "add", session["ai"].bet) if session["ai"].total == 21
end

def next_round_possible
  possible = false
  session["num_players"].times do |player|
    if session["player#{player}"].chips > 0
      return true
    end
  end
  return possible
end

def reset_dealer
  session["dealer"].reveal = false
  session["dealer"].hand = deal(session["shoe"])
  session["dealer"].total = player_total(session["dealer"].hand)
  session["dealer"].total_showing = dealer_total_showing(session["dealer"].hand, session["dealer"].reveal)
end

def reset_players
  session["num_players"].times do |player|
    session["player#{player}"].hand = deal(session["shoe"])
    session["player#{player}"].total = player_total(session["player#{player}"].hand)
    session["player#{player}"].bet = 0
    session["player#{player}"].insurance_bet = 0
    session["player#{player}"].split_hand = []
    session["player#{player}"].split_total = 0
    session["player#{player}"].split_bet = 0
  end
end

def reset_one_player(player)
  player.hand = []
  player.total = 0
  player.bet = 0
  player.insurance_bet = 0
  player.split_hand = []
  player.split_total = 0
  player.split_bet = 0
end

def reset_ai
  session["ai"].hand = deal(session["shoe"])
  session["ai"].total = player_total(session["ai"].hand)
  session["ai"].bet = 0
  session["ai"].insurance_bet = 0
  session["ai"].split_hand = []
  session["ai"].split_total = 0
  session["ai"].split_bet = 0
end

def most_chips
  most_chips = 0
  winner = session["ai"]
  session["num_players"].times do |player|
    if session["player#{player}"].chips > most_chips
      most_chips = session["player#{player}"].chips
      winner = session["player#{player}"]
    end
  end
  if session["ai"].chips > most_chips
    winner = session["ai"]
  end
  return winner
end

def split_up_hand(player)
  split_card = player.hand.pop
  player.split_hand << split_card
  player.hand << session["shoe"].shift
  player.total = player_total(player.hand)
  player.split_hand << session["shoe"].shift
  player.split_total = player_total(player.split_hand)
  player.split_bet = player.bet
end

def hit(player)
  player.hand << session["shoe"].shift
  player.total = player_total(player.hand)
end

def split_hit(player)
  player.split_hand << session["shoe"].shift
  player.split_total = player_total(player.split_hand)
end

def bust(total)
  return total > 21
end

def ai_decide_hit(hand, total)
  hand.each do |card|
    if card.value == 11
      while total <= 18 do
        hand << session["shoe"].shift
        session["ai"].total = player_total(session["ai"].hand)
      end
    elsif ((session["dealer"].total_showing >= 7 ) && (session["dealer"].total_showing <= 11))
      while total <=17 do
        hand << session["shoe"].shift
        session["ai"].total = player_total(session["ai"].hand)
      end
    elsif ((session["dealer"].total_showing >=4) && (session["dealer"].total_showing <= 6))
      while total <= 12 do
        hand << session["shoe"].shift
        session["ai"].total = player_total(session["ai"].hand)
      end
    else
      while total <= 13 do
        hand << session["shoe"].shift
        session["ai"].total = player_total(session["ai"].hand)
      end
    end
  end
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
  attr_accessor :name, :chips, :hand, :bet, :insurance_bet, :split_hand,  :split_total, :split_bet, :total, :hand_stand, :split_stand
  def initialize(name, shoe)
    @name = name
    @chips = 1000
    @hand = deal(shoe)
    @total = player_total(@hand)
    @bet = 0
    @hand_stand = false
    @insurance_bet = 0
    @split_hand = []
    @split_total = 0
    @split_bet = 0
    @split_stand = false
  end
end #Player class

class Dealer
  attr_accessor :name, :hand, :total, :total_showing, :reveal
  def initialize(shoe)
    @name = "Conrad"
    @reveal = false
    @hand = deal(shoe)
    @total = player_total(@hand)
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
  if session["ai"] == "true"
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
  if session["player#{session["turn"]}"].bet <= session["player#{session["turn"]}"].chips
    session["player#{session["turn"]}"].chips = update_chips(session["player#{session["turn"]}"].chips, "subtract", session["player#{session["turn"]}"].bet)
  else
    session["player#{session["turn"]}"].bet = session["player#{session["turn"]}"].chips
    session["player#{session["turn"]}"].chips = update_chips(session["player#{session["turn"]}"].chips, "subtract", session["player#{session["turn"]}"].bet)
  end
  session["turn"] += 1
  if session["turn"] == session["num_players"]
    session["ai"].bet = 20
    session["ai"].chips = update_chips(session["ai"].chips, "subtract", session["ai"].bet) if session["ai"]
    options_set_up_validations
    erb :blackjack
  else
    erb :bet
  end
end

post '/insurance_options' do
  erb :insurance
end

post '/insurance_bet' do
  session["player#{session["turn"]}"].insurance_bet = params[:insurance_bet].to_i
  if session["player#{session["turn"]}"].insurance_bet <= session["player#{session["turn"]}"].chips
    session["player#{session["turn"]}"].chips = update_chips(session["player#{session["turn"]}"].chips, "subtract", session["player#{session["turn"]}"].insurance_bet)
  else
    session["player#{session["turn"]}"].insurance_bet = session["player#{session["turn"]}"].chips
    session["player#{session["turn"]}"].chips = update_chips(session["player#{session["turn"]}"].chips, "subtract", session["player#{session["turn"]}"].insurance_bet)
  end
  session["turn"] += 1
  if session["turn"] == session["num_players"]
    if session["dealer"].total == 21
      session["dealer"].reveal = true
      session["dealer"].total_showing = dealer_total_showing(session["dealer"].hand, session["dealer"].reveal)
      erb :dealer_blackjack
    else
      erb :no_dealer_blackjack
    end
  end
end

post '/settle_dealer_blackjack' do
  settle_dealer_blackjack
  if next_round_possible
    session["message"] = "The bets have been settled and your totals are below.  Would you like to play another round"
    erb :end_hand
  else
    session["winner"] = most_chips
    erb :end_game
  end
end

post '/reset' do
  session["another"] = params[:next_round]
  if session["another"] == "true"
    session["shoe"] = create_shoe
    session["turn"] = 0
    reset_dealer
    reset_players
    reset_ai
    erb :bet
  else
    session["winner"] = most_chips
    erb :end_game
  end
end

post '/player_blackjack_options' do
  session["num_players"].times do |p|
    if session["player#{p}"].total == 21
      session["player#{p}"].chips = update_chips(session["player#{p}"].chips, "add", session["player#{p}"].bet * 1.5)
      reset_one_player(session["player#{p}"])
    end
  end
  if session["ai"].total == 21
    session["ai"].chips = update_chips(session["ai"].chips, "add", session["ai"].bet * 1.5)
    reset_one_player(session["ai"])
  end
  session["need_insurance"] = false
  session["player_blackjack"] = false
  erb :blackjack
end

post '/split_options' do
  if (session["player#{session["turn"]}"].chips >= session["player#{session["turn"]}"].bet) && (session["player#{session["turn"]}"].hand[0].rank == session["player#{session["turn"]}"].hand[1].rank)
    split_up_hand(session["player#{session["turn"]}"])
  end
  session["turn"] += 1
  erb :split
end

post '/standard_turn_reset' do
  session["turn"] = 0
  erb :standard
end

post '/standard_options' do
  #params
  session["player#{session["turn"]}_hit"] = params[:hit]
  session["player#{session["turn"]}_split_hit"] = params[:split_hit]
  #hit
  if session["player#{session["turn"]}_hit"] == "true"
    hit(session["player#{session["turn"]}"])
    #bust
    if bust(session["player#{session["turn"]}"].total)
      session["standard_message"] = "You went over 21 and lose this hand."
      session["player#{session["turn"]}"].hand_stand = true
      erb :standard
    else
      session["standard_message"] = "You may continue to hit or stand."
      erb :standard
    end
  end
  #stand
  if session["player#{session["turn"]}_hit"] == "false"
    session["standard_message"] = "#{session["player#{session["turn"]}"]} stands."
    session["player#{session["turn"]}"].hand_stand = true
    erb :standard
  end #end main hitting

  if ((session["player#{session["turn"]}"].split_hand != nil) && (session["player#{session["turn"]}"].hand_stand))
    if session["player#{session["turn"]}_split_hit"] == "true"
      split_hit(session["player#{session["turn"]}"])
      #bust
      if bust(session["player#{session["turn"]}"].split_total)
        session["standard_message"] = "You went over 21 and lose this hand."
        session["player#{session["turn"]}"].split_stand = true
        session["turn"] += 1
        erb :standard
      else
        session["standard_message"] = "You may continue to hit or stand."
        erb :standard
      end
    erb :standard
    end
    #stand
    if session["player#{session["turn"]}_split_hit"] == "false"
      session["player#{session["turn"]}"].hand_stand = true
      session["turn"] +=1
      erb :standard
    end #end split hitting
  elsif (session["player#{session["turn"]}"].hand_stand)
    session["turn"] += 1
    erb :standard
  else
    erb :standard
  end
  erb :standard
end
