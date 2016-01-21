#!/usr/bin/env ruby

require 'sinatra'
require 'thin'
require 'pry-byebug'
require 'sinatra/reloader' if development?
require './helpers/session_helper.rb'
require './lib/blackjack.rb'

also_reload 'lib/*'
also_reload 'helpers/*'

enable :sessions

helpers SessionHelper

get '/' do
  erb :home
end

get '/blackjack' do
  if session[:player_hand]
    @blackjack = load_session
  else
    @blackjack = new_game
  end
  
  erb :game
end

post '/blackjack/hit' do
  @blackjack = load_session

  @blackjack.deal(@blackjack.player_hand)

  save_session(@blackjack)

  session[:status] = "hit"

  redirect '/blackjack'
end

post '/blackjack/stay' do
  @blackjack = load_session

  @blackjack.dealers_turn

  save_session(@blackjack)

  session[:status] = "round_over"

  redirect '/blackjack'
end

post '/blackjack/split' do
  redirect '/blackjack'
end

post '/blackjack/double' do
  redirect '/blackjack'
end

post '/blackjack/new_game' do
  new_game
  session[:status] = "play"
  redirect '/blackjack'
end
