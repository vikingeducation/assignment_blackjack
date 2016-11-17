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
    game_start

    redirect to('game_over') if blackjack?(session['player_cards'])
    redirect to('game_over') if blackjack?(session['dealer_cards'])
  end

  if params[:hit]
    hit_player

    redirect to('game_over') if busted?(session['player_cards'])
  end

  erb :blackjack, locals: {
                            bet_placed: bet_placed,
                            player_cards: session['player_cards'],
                            dealer_cards: session['dealer_cards'],
                          }
end

get '/game_over' do
  <h1>GAME OVER</h1>
end
