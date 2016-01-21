require 'sinatra'
require "sinatra/reloader" if development?
require 'pry-byebug'

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
  session[:player_hand] = game.player.hand
  session[:dealer_hand] = game.dealer.hand
  session[:deck] = game.deck
  unless params[:bankroll].nil?
    session[:bankroll] = params[:bankroll].to_i
  end

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bankroll => session[:bankroll]}
end


post '/bet' do
  game = Blackjack.new
  load_game(game)
  session[:bet] = params[:bet].to_i

  if game.player.has_bankroll?(session[:bet])
    session[:bankroll] = game.player.make_bet(session[:bet])
  else
    redirect '/blackjack', 307
  end

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bet => session[:bet],
    :bankroll => session[:bankroll]
  }
end

get '/hit' do
  game = Blackjack.new
  load_game(game)
  game.hit(game.player)
  session[:deck] = game.cards.deck  
  if game.bust?(game.player)
    redirect '/end'
  end 

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bet => session[:bet],
    :bankroll => session[:bankroll]
  }
end

get '/stay' do
  game = Blackjack.new
  load_game(game)
  game.stay(session[:bet])
  session[:victory] = true
  session[:bankroll] = game.player.bankroll

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bet => session[:bet],
    :bankroll => session[:bankroll]
    :victory => session[:victory]
  }
end

get '/double' do
end

get '/split' do
end


