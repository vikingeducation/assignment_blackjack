require 'sinatra'
require 'erb'
require 'pry'
require 'json'
require_relative 'card_deck'

# saves deck and hands
enable :sessions

get '/' do
  erb :index
end

get '/blackjack' do
  # if session[:deck_arr]
  #   @deck = CardDeck.new(JSON.parse( session[:deck_arr] ))
  # else
    @deck = CardDeck.new
  # end

  @deck.deal(@deck.deck_arr)
  session[:deck_arr] = @deck.deck_arr.to_json
  session[:player_hand] = @deck.player_hand.to_json
  session[:dealer_hand] = @deck.dealer_hand.to_json

  erb :blackjack, locals: {player_hand: @deck.player_hand, dealer_hand: @deck.dealer_hand}
end