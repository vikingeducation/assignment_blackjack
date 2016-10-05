require 'sinatra'
require './deck.rb'
require 'json'
require 'pry-byebug'
require './helpers.rb'
require './bankroll.rb'


enable :sessions

include Helper

get '/' do

	#clear_plyr_dlr_deck

	session.clear

	parse_and_assign_bankroll

	save_bank

	erb :home

end


get '/bet' do

	parse_and_assign_bankroll
	parse_and_assign_variables


	save_bank
	save_session

	erb :bet, locals: { bankroll: @bankroll }

end

get '/new_game' do

	parse_session

	new_game

	assign_variables

	parse_and_assign_bankroll

	save_session
	save_bank

	redirect('/bet')

end

post '/blackjack' do

  parse_and_assign_variables
	parse_and_assign_bankroll

	save_bank
	save_session

	erb :blackjack, locals: { dealer: @dealer, player: @player }

end

post '/blackjack/bet/validate' do

	parse_and_assign_bankroll

	@bank.bet = params[ :bet ].to_i



	parse_and_assign_variables
	save_session

	if @bank.valid_bet?

		save_bank

		erb :blackjack, locals: { dealer: @dealer, player: @player, bankroll: @bankroll }

	else
		erb :bet, locals: { bankroll: @bankroll }
	end

end


post '/hit' do


  parse_and_assign_variables

	@player += @game.hit

  parse_and_assign_bankroll
  save_bank

	save_session

	erb :blackjack, locals: { dealer: @dealer, player: @player }

end


post '/stay' do

 	parse_and_assign_variables
  parse_and_assign_bankroll
	# when staying, the dealer will commence hand
	start_dealer_turn

	@bank.evaluate_hands( @game, @dealer, @player )

  save_bank

	save_session

	erb :stay, locals: { dealer: @dealer, player: @player }

end
