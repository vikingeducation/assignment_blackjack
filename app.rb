#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require_relative "./helpers/bet_helper"
require_relative "./helpers/cards_helper"

enable :sessions
helpers BetHelper, CardsHelper

get '/' do
  bankroll = load_bankroll
  erb :landing, locals: { bankroll: bankroll}
end

get '/blackjack' do
  place_bet( params[:bet] ) unless params[:bet].nil?
  bet_placed = load_bet

  p bet_placed.nil?
  p session['player_cards'].nil?

  if bet_placed.nil? && session["player_cards"].nil?
    p "Loop is ran!"
    player_cards = [draw_from_deck,draw_from_deck]
    dealer_cards = [draw_from_deck,draw_from_deck]
    save_cards(player_cards, dealer_cards)
  end

  if params[:hit]
    session["player_cards"] << draw_from_deck
  elsif params[:stay] # or if bust
    # go in to dealers turn
  end

  erb :blackjack, locals: {
                          bet_placed: bet_placed,
                          player_cards: player_cards,
                          dealer_cards: dealer_cards
                          }
end
