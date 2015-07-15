#!/usr/bin/env ruby

require 'thin'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'pry'
require './helpers/deal_hands.rb'
require 'json'
require_relative './helpers/player.rb'
set :server, "thin"
enable :sessions
helpers Deck

helpers do

	def new_game
		@deck = Deck::DealHands.new
    session[:dealer_hand] = @deck.dealer_hand.to_json
    session[:player_hand] = @deck.player_hand.to_json
    session[:game_deck] = @deck.game_deck.to_json
    @deck
	end

  def new_bank
    @player = Player.new
    session[:bank] = @player.bankroll
    @player
  end

	def load_game
		Deck::DealHands.new(JSON.parse(session[:player_hand]),
                  JSON.parse(session[:dealer_hand]),
                  JSON.parse(session[:game_deck]))
	end

  def load_bank
    Player.new(session[:bank])
  end

end


#kick off with user pushing button to play
get '/' do
  erb :index
end

get '/bet' do

  if session[:bank]
    @bank = load_bank
  else
    @bank = new_bank
  end

  warning = session[:warning]

  erb :bet, locals: {warning: warning}

end

post '/bet' do

  bank = load_bank
  bet = params[:user_bet].to_i
  binding.pry

  if bet > bank.bankroll
    session[:warning] = true
    redirect '/bet'
  else
    session[:warning] = nil
    bank.bankroll -= bet
    session[:bet] = bet
    session[:bank] = bank.bankroll
    redirect '/blackjack'
  end

end

#load initial hands and render them
get '/blackjack' do
  if session[:game_deck] && session[:dealer_hand] && session[:player_hand]
   	@deck = load_game
  else
  	@deck = new_game
  end
  erb :blackjack
end

#user can select to hit or stay
post '/blackjack/hit' do
	@deck = load_game
  session[:player_hand] = @deck.deal_to_player.to_json
  session[:game_deck] = @deck.game_deck.to_json
	#conditional logic to calculate card_value
  if @deck.count_hand_value(@deck.player_hand) > 21
    redirect '/blackjack/stay'
	else
    redirect '/blackjack'
  end
end

#user
get '/blackjack/stay' do
	@deck = load_game
	if @deck.count_hand_value(@deck.player_hand) < 21
		@deck.deal_to_dealer until @deck.count_hand_value(@deck.dealer_hand) >= 17
	end
	results = @deck.check_who_won
	session.clear
	erb :stay, :locals => {results: results}
end
