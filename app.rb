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
  unless bet_placed.nil?
    player_cards = [draw_from_deck,draw_from_deck]
    dealer_cards = [draw_from_deck,draw_from_deck]
    save_cards(player_cards, dealer_cards)
  end
  erb :blackjack, locals: {
                          bet_placed: bet_placed,
                          player_cards: player_cards,
                          dealer_cards: dealer_cards
                          }
end
