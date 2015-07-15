#!/usr/bin/env ruby

require 'thin'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'pry'
require './helpers/deal_hands.rb'
require 'json'
set :server, "thin"
enable :sessions
helpers Deck


#kick off with user pushing button to play
get '/' do
  erb :index
end

#load initial hands and render them
get '/blackjack' do
  if session[:player_hand]
    @deck = Deck::DealHands.new(JSON.parse(session[:player_hand]),
                JSON.parse(session[:dealer_hand]),
                JSON.parse(session[:deck]))
  else
  	@deck = Deck::DealHands.new
  	session[:dealer_hand] = @deck.dealer_hand.to_json
  	session[:player_hand] = @deck.player_hand.to_json
    session[:deck] = @deck.game_deck.to_json
  end
  erb :blackjack
end

#user can select to hit or stay
post '/blackjack/hit' do
	@deck = Deck::DealHands.new(JSON.parse(session[:player_hand]),
								JSON.parse(session[:dealer_hand]),
                JSON.parse(session[:deck]))
  @deck.deal_to_player
	#conditional logic to calculate card_value
  if @deck.count_hand_value(@deck.player_hand) > 21
    redirect '/blackjack/stay'
	else
    redirect '/blackjack'
  end
end

#user
post '/blackjack/stay' do

end
