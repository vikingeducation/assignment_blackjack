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

  save_deck(deck.cards)
  save_player_hand(player_hand.cards)
  save_dealer_hand(dealer_hand.cards)

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

  player_hand.cards << deck.hit

  save_deck(deck.cards)
  save_player_hand(player_hand.cards)
  save_dealer_hand(dealer_hand.cards)

  redirect "/blackjack/stay" if sum(player_hand.cards) > 21
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
  message = determine_results(dealer_hand, player_hand)

  erb :blackjack, locals: { player_hand: player_hand.cards, 
                            dealer_hand: dealer_hand.cards, 
                            message: message,
                            player_sum: sum(player_hand.cards), 
                            dealer_sum: sum(dealer_hand.cards) }
end



