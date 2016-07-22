require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require './classes/blackjack'
require './helpers/blackjack_helper'
# also_reload './views'

helpers BlackjackHelper
enable :sessions

get '/' do
  "<h1>Welcome!</h1><br><a href='/blackjack/bet'>Play blackjack!</a>"
end

get '/blackjack/bet' do
  game = make_blackjack
  bank = get_bank
  erb :bet
end

post '/blackjack/bet' do
  session["bet"] = params[:bet]
  bet = get_bet
  bank = get_bank

  redirect ('blackjack')
end

get '/blackjack' do
  winner = session[:condition]

  game = make_blackjack
  save_game(game) unless get_player_hand
  winner = game.end_game if game.over? 
  erb :blackjack, locals: { player_hand: get_player_hand, dealer_hand: get_dealer_hand, condition: winner, bet: bet}
end

post '/blackjack/hit' do
  game = make_blackjack
  game.give_card(game.player_hand)
  #check for end
  save_game(game)
  # add_card

  redirect ('blackjack')
end

post '/blackjack/stay' do
  game = make_blackjack
  game.dealer_play
  session[:condition] = game.end_game
  save_game(game)
  redirect ('blackjack')
end
