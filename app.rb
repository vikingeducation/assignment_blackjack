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
  if new_game?
    deck = load_deck
    player_hand = load_hand
    dealer_hand = load_dealer_hand
  else
    save_deck( Deck.new.deck_arr )
    save_hand( Hand.new.hand_arr )
    save_dealer_hand( DealerHand.new.hand_arr )
  end

  erb :blackjack, locals: { deck: deck,
                            player_hand: player_hand,
                            dealer_hand: dealer_hand}
end


post '/blackjack/hit' do
  deck = Deck.new(session["deck_arr"])
  card = deck.deal
  deck = save_deck(deck.deck_arr)

  player_hand = save_hand(Hand.new(load_hand).hit(card))
  dealer_hand = save_dealer_hand(DealerHand.new.hand_arr)

  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: dealer_hand}
end

post '/blackjack/stay' do
  deck = Deck.new(session["deck_arr"])
  card = deck.deal
  deck = save_deck(deck.deck_arr)

  player_hand = Hand.new(load_hand).hand_arr
  save_hand(player_hand)

  dealer_hand_new = DealerHand.new(load_dealer_hand)
  dealer_hand_new.get_moves
  dealer_hand = dealer_hand_new.hand_arr
  save_dealer_hand(dealer_hand)

  erb :blackjack, locals: { deck: deck, player_hand: player_hand, dealer_hand: dealer_hand}
end


