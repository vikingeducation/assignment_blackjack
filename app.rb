require 'sinatra'
require "sinatra/reloader" if development?

require './blackjack.rb'
require './card_helper.rb'

helpers CardHelper
enable :sessions

get '/' do
  erb :index
end

post '/blackjack' do
  game = Blackjack.new
  game.new_hand
  session[:player_hand] = get_hand(game.player.hand)
  session[:dealer_hand] = get_hand(game.dealer.hand)
  session[:deck] = game.deck
  session[:bankroll] = params[:bankroll]

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bankroll => session[:bankroll]}
end

post '/bet' do
  game = Blackjack.new
  load_game(game)
  session[:bet] = params[:bet]

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bet => session[:bet],
    :bankroll => session[:bankroll]
  }
end

get '/hit' do

end

get '/stay' do
end

get '/double' do
end

get '/split' do
end
