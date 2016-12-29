require 'sinatra'
require 'json'
require 'pry'
require './helpers/blackjack_helper.rb'
require './helpers/deck.rb'
require './helpers/player.rb'

helpers BlackjackHelper

enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  deck = Deck.new
  player_hand = Player.new(deck.deal_hand)
  dealer_hand = Player.new(deck.deal_hand)

  save_sessions(deck.cards, player_hand.cards, dealer_hand.cards)

  erb :blackjack, locals: { player_hand: player_hand.cards, 
                            dealer_hand: dealer_hand.cards, 
                            message: nil, 
                            player_sum: nil, 
                            dealer_sum: nil  }
end

post '/blackjack/hit' do
  deck = Deck.new(load_deck)
  player_hand = Player.new(load_player_hand)
  dealer_hand = Player.new(load_dealer_hand)

  player_hits(player_hand, deck)

  save_sessions(deck.cards, player_hand.cards, dealer_hand.cards)

  redirect "/blackjack/stay" if player_hand.sum > 21
  erb :blackjack, locals: { player_hand: player_hand.cards, 
                            dealer_hand: dealer_hand.cards, 
                            message: nil, 
                            player_sum: nil, 
                            dealer_sum: nil }
end

get '/blackjack/stay' do
  deck = Deck.new(load_deck)
  player_hand = Player.new(load_player_hand)
  dealer_hand = Player.new(load_dealer_hand)

  dealer_hits(dealer_hand, deck)
  message = determine_results(dealer_hand.sum, player_hand.sum)

  erb :blackjack, locals: { player_hand: player_hand.cards, 
                            dealer_hand: dealer_hand.cards, 
                            message: message,
                            player_sum: player_hand.sum, 
                            dealer_sum: dealer_hand.sum }
end



