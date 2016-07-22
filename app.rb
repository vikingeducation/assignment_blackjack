require 'sinatra'
require 'erb'
require './helpers/blackjack_helper.rb'

helpers BlackjackHelper

get '/' do
  erb :index
end

get '/blackjack' do

  player_hand = BlackjackHelper.deal_hand 
  dealer_hand = BlackjackHelper.deal_hand
  responds.set_cookie("player_hand", player_hand)
  repsonds.set_cookie("player_hand", player_hand)
  erb :blackjack, :locals =>{:dealer_hand => dealer_hand, :player_hand => player_hand }

end

post '/hit' do

