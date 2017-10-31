require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry'

# Helpers
require './helpers/blackjack_helper'
helpers BlackjackHelper

# Routes
enable :sessions

get '/' do
  session['bankroll'] = 100
  session['game_over'] = false
  erb :index
end

get '/blackjack' do

  deck = build_deck
  session['dealer_hand'] = deck.pop(2)
  session['player_hand'] = deck.pop(2)
  session['deck'] = deck

  dealer_hand = session['dealer_hand']
  player_hand = session['player_hand']

  dealer_hand_value = calculate_hand(dealer_hand)
  player_hand_value = calculate_hand(player_hand)

  bankroll = session['bankroll']
  bet = 10
  session['bet'] = bet
  game_over = session['game_over']

  erb :blackjack, locals: { dealer_hand: dealer_hand, player_hand: player_hand, dealer_hand_value: dealer_hand_value, player_hand_value: player_hand_value, bankroll: bankroll, bet: bet, game_over: game_over }
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
    dealer_hand_value = calculate_hand(dealer_hand)
    player_hand_value = calculate_hand(player_hand)

    bankroll = session['bankroll']
    bet = session['bet']

    game_over = session['game_over']
    if game_ending_hand?(player_hand_value)
      game_over = true
      winner = determine_winner(dealer_hand_value, player_hand_value)
    else
      winner = 'No winner'
    end

    erb :blackjack, locals: { dealer_hand: dealer_hand, player_hand: player_hand, dealer_hand_value: dealer_hand_value, player_hand_value: player_hand_value, bankroll: bankroll, bet: bet, winner: winner, game_over: game_over }
  else
    redirect('/blackjack/stay')
  end
end

get '/blackjack/stay' do
  player_hand = session['player_hand']
  player_hand_value = calculate_hand(player_hand)
  @dealer_hand = session['dealer_hand']
  @dealer_hand_value = calculate_hand(@dealer_hand)

  @deck = session['deck']

  while @dealer_hand_value < 17
    @dealer_hand = session['dealer_hand'] << @deck.pop
    @dealer_hand_value = calculate_hand(@dealer_hand)
  end
  session['dealer_hand'] = @dealer_hand
  session['deck'] = @deck

  winner = determine_winner(@dealer_hand_value, player_hand_value)
  game_over = true
  session['game_over'] = game_over

  bankroll = session['bankroll']
  bet = session['bet']

  erb :blackjack, locals: { dealer_hand: @dealer_hand, player_hand: player_hand, dealer_hand_value: @dealer_hand_value, player_hand_value: player_hand_value, bankroll: bankroll, bet: bet, winner: winner, game_over: game_over }
end
