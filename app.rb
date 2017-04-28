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
  session["dealer_reveal"] = false
  session["dealer_total_showing"] = dealer_total_showing(session["dealer_hand"], false)
  session["num_players"] = params[:num_players].to_i
  session["num_players"].times do |x|
    session["player#{x}_hand"] = deal(shoe)
    session["player#{x}_bank"] = 1000
    session["player#{x}_total"] = player_total(session["player#{x}_hand"])
  end
  session["ai"] = params[:ai]
  if session["ai"]
    session["ai_hand"] = deal(shoe)
    session["ai_bank"] = 1000
    session["ai_total"] = player_total(session["ai_hand"])
  end
  erb :blackjack
end

post '/bet' do
  session["ai_bet"] = ai_bet
  session["player#{session["turn"]}_bet"] = params[:bet]
  session["player#{session["turn"]}_bank"] =  update_bank(session["player#{session["turn"]}_bank"].to_i, "subtract", session["player#{session["turn"]}_bet"].to_i)

  session["turn"] += 1
  if session["turn"] == session["num_players"]
    erb :bet
  else
    erb :blackjack
  end
end
