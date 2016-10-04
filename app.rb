require 'sinatra'
require './deck.rb'
require 'json'
require 'pry-byebug'
require './helpers.rb'
require './bankroll.rb'


enable :sessions

include Helper

get '/' do

	clear_plyr_dlr_deck

	parse_and_assign_bankroll

	save_bank

	erb :home

end


get '/blackjack/bet' do

	parse_and_assign_bankroll

	save_bank

	erb :bet, locals: { bankroll: @bankroll }

end

post '/blackjack' do
binding.pry
  parse_and_assign_variables
	parse_and_assign_bankroll

	save_bank
	save_session

	erb :blackjack, locals: { dealer: @dealer, player: @player }

end

post '/blackjack/bet/validate' do

	parse_and_assign_bankroll

	@bet = params[ :bet ].to_i

	save_bank
binding.pry

	if @bank.valid_bet?

		parse_and_assign_variables
		save_session
		erb :blackjack, locals: { dealer: @dealer, player: @player }

	else
		redirect('/blackjack/bet/validate')
	end

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
