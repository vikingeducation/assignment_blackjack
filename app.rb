require 'sinatra'
require 'erb'
require './helpers/blackjack_helper.rb'

helpers BlackjackHelper

get '/' do
  erb :index
end

get '/blackjack' do
  player_hand = BlackjackHelper::deal_hand
  dealer_hand = BlackjackHelper::deal_hand
  erb :blackjack
end