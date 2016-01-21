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

  load_game
  session[:bankroll] = params[:bankroll]

  erb :blackjack, :locals => {:player_hand => player_hand, :dealer_hand => dealer_hand, :bankroll => session[:bankroll]}
end

post '/bet' do
  load_game
  erb :blackjack, :locals => {:bet => params[:bet], :bankroll => session[:bankroll]}
end

get '/hit' do
  
end

get '/stay' do
end

get '/double' do
end

get '/split' do
end
