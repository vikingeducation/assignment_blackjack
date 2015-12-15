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

  if session[:winner]
    winner = session[:winner]
    scores = JSON.parse(session[:scores])

    erb :final, locals: {player_hand: player_hand, dealer_hand: dealer_hand, winner: winner, scores: scores}
  else
    erb :blackjack, locals: {player_hand: player_hand, dealer_hand: dealer_hand}
  end
end

post '/blackjack/hit' do
  @deck = load_deck
  player_hand = load_hand(session[:player_hand])

  values = @deck.hand_values(player_hand)
  if @deck.bust?(values)
    redirect to('/blackjack/stay')
  else
    @deck.hit(player_hand)
    session[:deck_arr] = @deck.deck_arr.to_json
    session[:player_hand] = player_hand.to_json

    redirect to('/blackjack')
  end
end

get '/blackjack/new' do
  @deck = CardDeck.new

  @deck.deal(@deck.deck_arr)
  player_hand = @deck.player_hand
  dealer_hand = @deck.dealer_hand
  session[:player_hand] = player_hand.to_json
  session[:dealer_hand] = dealer_hand.to_json

  if @deck.blackjack?
    set_winner_and_scores(player_hand, dealer_hand)
    redirect to('/blackjack')
  else
    session[:deck_arr] = @deck.deck_arr.to_json
    session[:scores] = nil
    session[:winner] = nil
    redirect to('/blackjack')
  end
end

get '/blackjack/stay' do
  @deck = load_deck
  dealer_hand = load_hand(session[:dealer_hand])
  player_hand = load_hand(session[:player_hand])

  loop do
    values = @deck.hand_values(dealer_hand)
    break if @deck.stop?(values)
    @deck.hit(dealer_hand)
  end
  session[:dealer_hand] = dealer_hand.to_json

  set_winner_and_scores(player_hand, dealer_hand)
  redirect to('/blackjack')
end