#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require './helpers/blackjack_helpers.rb'

helpers BlackjackHelpers

enable :sessions


get '/' do
  erb :index
end

get '/blackjack' do

  face_card_values = {
    A: 1,
    K: 10,
    Q: 10,
    J: 10
  }


  erb :blackjack, locals: { player_hand: session[:player_hand], bank_roll: session[:bank_roll], dealer_hand: session[:dealer_hand], message: session[:message] }
end

post '/blackjack' do
  session[:player_hand] = deal
  session[:dealer_hand] = deal
  session[:bank_roll] = reset_bank

  redirect to('blackjack')
end

post "/hit" do 
  session[:turn] = "player_hand"
  current_turn = session[:turn]
  hit(current_turn)
  # render("Ya blew it") if bust?(current_turn)
  redirect to('blackjack')
end