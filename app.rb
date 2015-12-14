require 'sinatra'
require 'erb'
require 'pry'
require 'json'
require_relative 'card_deck'
require_relative 'helpers/blackjack_helper'

helpers BlackjackHelper

# saves deck and hands
enable :sessions

get '/' do
  erb :index
end

get '/blackjack' do
  if session[:deck_arr]
    @deck = load_deck
  else
    redirect to ('/blackjack/new')
  end

  player_hand = load_hand(session[:player_hand])
  dealer_hand = load_hand(session[:dealer_hand])

  # TODO: delete deck when done
  erb :blackjack, locals: {player_hand: player_hand, dealer_hand: dealer_hand, deck: @deck.deck_arr}
end

post '/blackjack/hit' do
  @deck = load_deck
  player_hand = load_hand(session[:player_hand])

  @deck.hit(player_hand)
  session[:deck_arr] = @deck.deck_arr.to_json
  session[:player_hand] = player_hand.to_json

  redirect to('/blackjack')
end

get '/blackjack/new' do
  @deck = CardDeck.new

  @deck.deal(@deck.deck_arr)
  session[:deck_arr] = @deck.deck_arr.to_json
  session[:player_hand] = @deck.player_hand.to_json
  session[:dealer_hand] = @deck.dealer_hand.to_json

  redirect to('/blackjack')
end