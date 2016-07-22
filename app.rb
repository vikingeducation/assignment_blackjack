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
  save_game(game)
  erb :bet
end

post '/blackjack/bet' do
  session["bet"] = params[:bet]
  if enough_money?(get_bet)
    redirect('blackjack')
  else
    redirect('blackjack/bet')
  end
end

post '/blackjack/reset' do
  reset
  redirect('blackjack/bet')
end

get '/blackjack' do
  winner = session[:condition]
  game = make_blackjack
  save_game(game) unless get_player_hand
  if game.over?
    winner = game.end_game(get_bet)
    save_game(game)
  end
  erb :blackjack, locals: { player_hand: get_player_hand, dealer_hand: get_dealer_hand, condition: winner}
end

post '/blackjack/hit' do
  game = make_blackjack
  game.give_card(game.player_hand)
  save_game(game)
  redirect('blackjack')
end

post '/blackjack/stay' do
  game = make_blackjack
  game.dealer_play(get_bet)
  session[:condition] = game.end_game(get_bet)
  save_game(game)
  redirect('blackjack')
end
