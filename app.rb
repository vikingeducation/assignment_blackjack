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

  # if session[:player_hand]
    # add up all hands and store it in a 'round' array
    # round.each
      # if the player's hand is 21
        # player wins
      # if players hand is > 21
        # player loses
      # else
        # continue playing

    # while player_hand < 21
      # hit
        # push new card to player's hand
      # stay
        # do nothing

    # check hands
      # 21 - player's hand / 21 - d

  erb :blackjack, locals: { player_hand: session[:player_hand], bank_roll: session[:bank_roll], dealer_hand: session[:dealer_hand] }
end

post '/blackjack' do
  session[:player_hand] = deal
  session[:dealer_hand] = deal

  redirect to('blackjack')
end
