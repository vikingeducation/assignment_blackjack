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

  parse_session

	assign_variables

	save_session

	erb :blackjack, locals: { dealer: @dealer, player: @player }

end


post '/hit' do


	parse_session

	assign_variables

	@player += @game.hit

	save_session

	erb :blackjack, locals: { dealer: @dealer, player: @player }

end


post '/stay' do

	parse_session

	assign_variables

	# when staying, the dealer will commence hand
	dealer_total = start_dealer_turn( @dealer )

	dealer_ai( dealer_total )

	save_session

	erb :blackjack, locals: { dealer: @dealer, player: @player }

end
