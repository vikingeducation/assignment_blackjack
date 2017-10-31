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
  bet = 10

  # save objects to session
  session['dealer'] = dealer
  session['player'] = player
  session['deck'] = deck
  session['bet'] = bet

  # output objects to view
  erb :blackjack, locals: { dealer: dealer, player: player, bet: bet, game_over: game_over }
end

post '/blackjack/hit' do
  # retrieve objects
  deck = session['deck']
  dealer = session['dealer']
  player = session['player']
  bet = session['bet']
  game_over = session['game_over']

  # modify objects
  if player.hand_value < 21
    player.hand << deck.pop
    player.set_hand_value

    if game_ending_hand?(player.hand_value)
      game_over = true
      winner = determine_winner(dealer.hand_value, player.hand_value)
    else
      winner = 'No winner'
    end

    # save objects to session
    session['deck'] = deck
    session['player'] = player
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
  @dealer = session['dealer']
  player = session['player']
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
  session['dealer'] = @dealer
  session['game_over'] = game_over
  bet = session['bet']

  # output objects to view
  erb :blackjack, locals: { dealer: @dealer, player: player, bet: bet, winner: winner, game_over: game_over }
end
