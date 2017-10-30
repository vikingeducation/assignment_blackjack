require 'sinatra'
require "sinatra/reloader" if development?
require 'erb'
require 'pry'

# Helpers
require './helpers/blackjack_helper'
helpers BlackjackHelper

# Routes
enable :sessions

get '/' do
  session['bankroll'] = 100
  erb :index
end

get '/blackjack' do
  deck = build_deck
  session['deck'] = deck

  session['dealer_hand'] = deck.pop(2)
  dealer_hand = session['dealer_hand']
  dealer_hand_value = calculate_hand(dealer_hand)

  session['player_hand'] = deck.pop(2)
  player_hand = session['player_hand']
  player_hand_value = calculate_hand(player_hand)

  bankroll = session['bankroll']
  bet = 10
  session['bet'] = bet

  erb :blackjack, locals: { dealer_hand: dealer_hand, player_hand: player_hand, dealer_hand_value: dealer_hand_value, player_hand_value: player_hand_value, bankroll: bankroll, bet: bet }
end

post '/blackjack/hit' do
  player_hand = session['player_hand']
  player_hand_value = calculate_hand(player_hand)

  if player_hand_value < 21
    deck = session['deck']
    player_hand = session['player_hand'] << deck.pop
    session['player_hand'] = player_hand
    session['deck'] = deck

    dealer_hand = session['dealer_hand']
    bankroll = session['bankroll']
    bet = session['bet']

    erb :blackjack, locals: { dealer_hand: dealer_hand, player_hand: player_hand, dealer_hand_value: dealer_hand_value, player_hand_value: player_hand_value, bankroll: bankroll, bet: bet }
  else
    redirect('/blackjack/stay')
  end
end

get '/blackjack/stay' do
  player_hand = session['player_hand']
  player_hand_value = calculate_hand(player_hand)
  @dealer_hand = session['dealer_hand']
  @dealer_hand_value = calculate_hand(dealer_hand)

  @deck = session['deck']

  while @dealer_hand_value < 17
    @dealer_hand = session['dealer_hand'] << @deck.pop
    @dealer_hand_value = calculate_hand(dealer_hand)
  end

  session['dealer_hand'] = @dealer_hand
  session['deck'] = @deck

  bankroll = session['bankroll']
  bet = session['bet']

  erb :blackjack, locals: { dealer_hand: @dealer_hand, player_hand: player_hand, dealer_hand_value: @dealer_hand_value, player_hand_value: player_hand_value, bankroll: bankroll, bet: bet }
end
