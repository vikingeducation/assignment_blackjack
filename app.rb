require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/deck'
require './lib/dealer_hand'
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
  if not_new_game?
    deck = load_deck
    player_hand = load_hand
    dealer_hand = load_dealer_hand
  else
    save_hand(Hand.new(deal_two_cards).hand_arr)
    save_dealer_hand(Hand.new(deal_two_cards).hand_arr)
    save_deck( Deck.new.deck_arr )
  end

  erb :blackjack, locals: { deck: load_deck,
 player_hand: load_hand, dealer_hand: load_dealer_hand}
end


post '/blackjack/hit' do
  deck = Deck.new(load_deck)
  card = deck.deal
  deck = save_deck(deck.deck_arr)

  player_hand = save_hand(Hand.new(load_hand).hit(card))

  redirect to('bust') if Hand.new(load_hand).bust?

  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: load_dealer_hand}
end

post '/blackjack/stay' do
  get_dealer_moves
  erb :blackjack, locals: { deck: load_deck, player_hand: load_hand, dealer_hand: load_dealer_hand}
end

get '/bust' do
  get_dealer_moves
  erb :blackjack, locals: { deck: load_deck, player_hand: load_hand, dealer_hand: load_dealer_hand}
end


