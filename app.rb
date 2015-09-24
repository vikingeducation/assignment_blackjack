require 'sinatra'
require 'json'
require 'pry-byebug'
require_relative 'lib/card.rb'
require_relative 'lib/deck.rb'
require_relative 'lib/player.rb'

#helpers BlackjackHelper

enable :sessions

get '/' do 
  # sets up the game

  deck = Deck.new
  hand = [deck.pop, deck.pop]
  player = Player.new(hand)
  @bankroll = session["bankroll"] || 1000

  dealer_hand = [deck.pop, deck.pop]
  dealer = Player.new(dealer_hand)

  session["bankroll"] = @bankroll
  session["player_hand"] = player.hand
  session["dealer_hand"] = dealer.hand
  session["deck"] = deck.cards

  erb :index#, :locals => [:bankroll => bankroll]
end

post '/' do
  bet = params[:bet].to_i

  session["bet"] = bet

  redirect to('/blackjack')
end

get '/blackjack' do
  @player_hand = Player.new(session["player_hand"]).hand_to_s
  @dealer_hand = Player.new(session["dealer_hand"]).hand_to_s
  @dealer_hand[0..3] = "[  ]" if !session["game_end"]
  @bankroll = session["bankroll"]
  @bet = session["bet"]

  if player_hand == 21
    session["game_end"] = "BLACKJACK!"
    session["bankroll"] += session["bet"]
  end

  erb :blackjack
end

post '/blackjack/stay' do
  player = Player.new(session["player_hand"])
  dealer = Player.new(session["dealer_hand"])
  deck = Deck.new(session["deck"]) 

  while dealer.hand_sum < 17
    dealer.hit(deck.pop)
  end

  #if player chooses to stay, we will check win conditions
  if dealer.hand_sum > 21
    session["game_end"] = "YOU WIN"
    session["bankroll"] += session["bet"]
  elsif dealer.hand_sum > player.hand_sum
    session["game_end"] = "YOU LOSE"
    session["bankroll"] -= session["bet"]
    redirect to('/blackjack/game_over') if session["bankroll"] <= 0
  elsif player.hand_sum > dealer.hand_sum 
    session["game_end"] = "YOU WIN"
    session["bankroll"] += session["bet"]
  elsif player.hand_sum == dealer.hand_sum 
    session["game_end"] = "PUSH"
  end

  session["deck"] = deck.cards
  session["dealer"] = dealer.hand

  redirect to('/blackjack')
end

post '/blackjack/hit' do
  player = Player.new(session["player_hand"])
  deck = Deck.new(session["deck"])

  player.hit(deck.pop)
  if player.hand_sum > 21
    session["game_end"] = "YOU LOSE"
    session["bankroll"] -= session["bet"]

    redirect to('/blackjack/game_over') if session["bankroll"] <= 0
  end

  session["deck"] = deck.cards
  session["player_hand"] = player.hand

  redirect to('/blackjack')
end

get '/blackjack/play_again' do
  #session.clear
  session.delete("game_end")
  redirect to('/')
end

get '/blackjack/game_over' do
  session.clear
  redirect to('/')
end