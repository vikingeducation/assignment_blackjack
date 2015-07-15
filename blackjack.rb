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

# helpers do

# 	def new_game
# 		@deck = Deck::DealHands.new
# 	end

# 	def load_game(player_hand, dealer_hand, deck)
# 		@deck = Deck::DealHands.new(player_hand, dealer_hand, deck)
# 	end

# end


#kick off with user pushing button to play
get '/' do
  erb :index
end

#load initial hands and render them
get '/blackjack' do
  if session[:game_deck] && session[:dealer_hand] && session[:player_hand]
   	@deck = Deck::DealHands.new(JSON.parse(session[:player_hand]),
    				JSON.parse(session[:dealer_hand]),
                	JSON.parse(session[:game_deck]))
  else
  	@deck = @deck = Deck::DealHands.new
  	session[:dealer_hand] = @deck.dealer_hand.to_json
  	session[:player_hand] = @deck.player_hand.to_json
    session[:game_deck] = @deck.game_deck.to_json
  end
  erb :blackjack
end

#user can select to hit or stay
post '/blackjack/hit' do
	@deck = Deck::DealHands.new(JSON.parse(session[:player_hand]),
					JSON.parse(session[:dealer_hand]),
                	JSON.parse(session[:game_deck]))
  	session[:player_hand] = @deck.deal_to_player.to_json
	#conditional logic to calculate card_value
  if @deck.count_hand_value(@deck.player_hand) > 21
    redirect '/blackjack/stay'
	else
    redirect '/blackjack'
  end
end

#user
get '/blackjack/stay' do
	@deck = Deck::DealHands.new(JSON.parse(session[:player_hand]),
					JSON.parse(session[:dealer_hand]),
                	JSON.parse(session[:game_deck]))
	if @deck.count_hand_value(@deck.player_hand) < 21
		@deck.deal_to_dealer until @deck.count_hand_value(@deck.dealer_hand) >= 17
	end
	results = @deck.check_who_won
	session.clear
	erb :stay, :locals => {results: results}
end
