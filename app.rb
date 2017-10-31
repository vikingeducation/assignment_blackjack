require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry'

# Helpers
require './helpers/blackjack_helper'
helpers BlackjackHelper

# Classes
require './models/deck.rb'
require './models/player.rb'

# Routes
enable :sessions

get '/' do
  session['game_over'] = false
  erb :index
end

get '/blackjack' do
  # set up objects
  deck = Deck.new.build_deck
  dealer = Dealer.new
  player = Player.new
  game_over = session['game_over']

  # modify objects
  dealer.hand = deck.pop(2)
  player.hand = deck.pop(2)
  dealer.set_hand_value
  player.set_hand_value

  # save objects to session
  session['deck'] = deck

  session['dealer_hand'] = dealer.hand
  session['dealer_hand_value'] = dealer.hand_value

  session['player_hand'] = player.hand
  session['player_hand_value'] = player.hand_value
  session['player_bankroll'] = player.bankroll

  # output objects to view
  erb :blackjack, locals: { dealer: dealer, player: player, bet: 0, game_over: game_over }
end

post '/blackjack/hit' do
  # retrieve objects
  deck = session['deck']
  dealer = Dealer.new(hand: session['dealer_hand'], hand_value: session['dealer_hand_value'])
  player = Player.new(hand: session['player_hand'], hand_value: session['player_hand_value'], bankroll: session['player_bankroll'])
  bet = params['bet'].to_i
  game_over = session['game_over']

  # modify objects
  if player.hand_value < 21
    player.hand << deck.pop
    player.set_hand_value
    player.add_winnings(bet)

    if player.game_ending_hand?
      game_over = true
      player.adjust_bankroll(bet)
      winner = determine_winner(dealer.hand_value, player.hand_value)
    else
      winner = 'No winner'
    end

    # save objects to session
    session['deck'] = deck

    session['player_hand'] = player.hand
    session['player_hand_value'] = player.hand_value
    session['player_bankroll'] = player.bankroll

    session['bet'] = bet
    session['game_over'] = game_over

    # output objects to view
    erb :blackjack, locals: { dealer: dealer, player: player, bet: bet, winner: winner, game_over: game_over }
  else
    redirect('/blackjack/stay')
  end
end

get '/blackjack/stay' do
  # retrieve objects
  @deck = session['deck']
  @dealer = Dealer.new(hand: session['dealer_hand'], hand_value: session['dealer_hand_value'])
  player = Player.new(hand: session['player_hand'], hand_value: session['player_hand_value'], bankroll: session['player_bankroll'])
  bet = session['bet']
  game_over = session['game_over']

  # modify objects
  while @dealer.hand_value < 17
    @dealer.hand << @deck.pop
    @dealer.set_hand_value
  end

  winner = determine_winner(@dealer.hand_value, player.hand_value)
  game_over = true

  # save objects to session
  session['deck'] = @deck

  session['dealer_hand'] = @dealer.hand
  session['dealer_hand_value'] = @dealer.hand_value

  session['game_over'] = game_over
  session['bet'] = bet

  # output objects to view
  erb :blackjack, locals: { dealer: @dealer, player: player, bet: bet, winner: winner, game_over: game_over }
end
