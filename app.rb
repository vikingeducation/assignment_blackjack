#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require './helpers/blackjack_helpers.rb'
require './helpers/messages.rb'

helpers BlackjackHelpers
helpers Messages

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


  erb :blackjack, locals: { player_hand: session[:player_hand],
                            bank_roll: session[:bank_roll],
                            dealer_hand: session[:dealer_hand],
                            message: session[:message] }
end

post '/blackjack' do
  reset_hands
  session[:bank_roll] = reset_bank
  session[:message] = nil
  redirect to('blackjack')
end

post "/hit" do
  session[:turn] = "player_hand"
  current_turn = session[:turn]
  hit(current_turn)
  if bust?(current_turn)
    reset_hands
    status_message(Messages::BUST)
  end
  if twenty_one?(current_turn)
    reset_hands
    status_message(Messages::WON)
  end
  redirect to('blackjack')
end

post '/stay' do
  # session[:turn] = "player_hand"
  current_turn = session[:turn]
  stay
  status_message(Messages::BUST) if bust?(current_turn)
  redirect to('blackjack')
end
