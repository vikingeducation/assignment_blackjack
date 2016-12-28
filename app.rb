require 'sinatra'
require 'json'
require 'pry'
require './helpers/blackjack_helper.rb'
require './helpers/deck.rb'

helpers BlackjackHelper

enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  deck = Deck.new
  player_hand = deck.deal_hand
  dealer_hand = deck.deal_hand

  save_deck(deck)
  save_player_hand(player_hand)
  save_dealer_hand(dealer_hand)

  display_player = player_hand.map {|card| card.value }
  display_dealer = dealer_hand.map {|card| card.value }

  erb :blackjack, locals: { player_hand: display_player, dealer_hand: display_dealer, message: nil }
end

post '/blackjack/hit' do
  deck = load_deck
  player_hand = load_player_hand
  dealer_hand = load_dealer_hand

  player_hand << deck.hit

  save_deck(deck)
  save_player_hand(player_hand)
  save_dealer_hand(dealer_hand)

  display_player = player_hand.map {|card| card.value }
  display_dealer = dealer_hand.map {|card| card.value }

  redirect "/blackjack/stay" if sum(player_hand) > 21
  erb :blackjack, locals: { player_hand: display_player, dealer_hand: display_dealer, message: nil }
end

get '/blackjack/stay' do
  binding.pry
  deck = load_deck
  player_hand = load_player_hand
  dealer_hand = load_dealer_hand

  dealer_hand << deck.hit until sum(dealer_hand) >= 17

  message = sum(dealer_hand) > sum(player_hand) ? "You lost!" : "You won!"
  message = "Bust!" if sum(player_hand) > 21

  display_player = player_hand.map {|card| card.value }
  display_dealer = dealer_hand.map {|card| card.value }

  erb :blackjack, locals: { player_hand: display_player, dealer_hand: display_dealer, message: message }
end



