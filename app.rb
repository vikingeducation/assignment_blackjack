require 'sinatra'
require "sinatra/reloader" if development?
require 'pry-byebug'

require './blackjack.rb'
require './card_helper.rb'

helpers CardHelper
enable :sessions

get '/' do
  session[:victory] = false
  erb :index
end

post '/blackjack' do
  game = Blackjack.new
  game.new_hand
  session[:player_hand] = game.player.hand
  session[:dealer_hand] = game.dealer.hand
  unless params[:bankroll].nil?
    session[:bankroll] = params[:bankroll].to_i
  end

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bankroll => session[:bankroll],
    :victory => session[:victory]}
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
    :bankroll => session[:bankroll],
    :victory => session[:victory]
  }
end

get '/hit' do
  game = Blackjack.new
  load_game(game)
  game.hit(game.player)
  if game.bust?(game.player)
    session[:victory] = true
    redirect '/end'
  end

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bet => session[:bet],
    :bankroll => session[:bankroll],
    :victory => session[:victory]
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
    :bankroll => session[:bankroll],
    :victory => session[:victory]
  }
end

get '/double' do
  game = Blackjack.new
  load_game(game)
  if game.double(game.player, session[:bet])
    session[:bankroll] -= session[:bet]
    session[:bet] *= 2
    session[:player_hand] = game.player.hand
    if game.bust?(game.player) == false
      redirect '/stay'
    else
      session[:victory] = true
      redirect '/end'
    end
  else
    #print message that double can't be done because you don't enough money
    redirect '/blackjack', 307
  end
end

get '/split' do
end

get '/end' do
  # game = Blackjack.new
  # game.new_hand
  # session[:player_hand] = game.player.hand
  # session[:dealer_hand] = game.dealer.hand

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bankroll => session[:bankroll],
    :victory => session[:victory],
    :bet => session[:bet] }
end

get '/new_hand' do
  game = Blackjack.new
  game.new_hand
  session[:bet] = nil

  session[:player_hand] = game.player.hand
  session[:dealer_hand] = game.dealer.hand
  session[:victory] = false

  erb :blackjack, :locals => {
    :player_hand => session[:player_hand],
    :dealer_hand => session[:dealer_hand],
    :bankroll => session[:bankroll],
    :victory => session[:victory]}
end
