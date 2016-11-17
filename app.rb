#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require_relative "./helpers/bet_helper"
require_relative "./helpers/cards_helper"
require_relative "./helpers/blackjack_helper"

enable :sessions
helpers BetHelper, CardsHelper, BlackjackHelper

get '/' do
  bankroll = load_bankroll
  erb :landing, locals: { bankroll: bankroll}
end

get '/blackjack' do
  place_bet( params[:bet] ) unless params[:bet].nil?
  bet_placed = load_bet

  if bet_placed.nil? && session["player_cards"].nil?
    card_array = game_start
    redirect to('game_over') if has_won? 
  end

  if params[:hit]
    card_array = hit_player
    redirect to('game_over') if busted?(session["player_cards"])   
  end

  erb :blackjack, locals: {
                          bet_placed: bet_placed,
                          player_cards: card_array[0],
                          dealer_cards: card_array[1],
                          }
end
