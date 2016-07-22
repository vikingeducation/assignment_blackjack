require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/deck'
require './lib/player'
require './lib/hand'
require './helpers/blackjack_helper'
require 'pry'
require 'json'

helpers BlackjackHelper

enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do
  #binding.pry
  if session["deck_arr"]
    deck = load_deck
  else
    deck = save_deck( Deck.new.deck_arr )
  end

  if session["player_hand_arr"]
    player_hand = load_player_hand
  else
    save_player_hand( Player.new.hand )
  end

  erb :blackjack, locals: { deck: deck, player_hand: player_hand }
end


post '/blackjack/hit' do
  deck = Deck.new(session["deck_arr"]).deck_arr
  card = deck.deal
  save_deck(deck)
  player_hand = save_player_hand(Player.new(load_player_hand).hit(card))

  erb :blackjack, locals: { deck: deck, player_hand: player_hand}
end