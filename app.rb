require 'sinatra'
require './deck.rb'
require 'json'
require 'pry-byebug'
require './helpers.rb'


enable :sessions

include Helper

get '/' do

	session.clear
	erb :home

end


post '/blackjack' do

  parse_and_assign_variables

	save_session

	erb :blackjack, locals: { dealer: @dealer, player: @player }

end


post '/hit' do


  parse_and_assign_variables

	@player += @game.hit

	save_session

	erb :blackjack, locals: { dealer: @dealer, player: @player }

end


post '/stay' do

 	parse_and_assign_variables

	# when staying, the dealer will commence hand
	start_dealer_turn

	evaluate_hands

	save_session

	erb :stay, locals: { dealer: @dealer, player: @player }

end
