require 'sinatra'
#require 'sinatra/reloader' if development?
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
    player_hand = load_hand
  else
    save_hand( Hand.new.hand_arr )
  end

  erb :blackjack, locals: { deck: deck, player_hand: player_hand }
end


post '/blackjack/hit' do
  deck = Deck.new(session["deck_arr"])
  card = deck.deal
  deck = deck.deck_arr

  save_deck(deck)
  player_hand = save_hand(Hand.new(load_hand).hit(card))

  erb :blackjack, locals: { deck: deck, player_hand: player_hand}
end



