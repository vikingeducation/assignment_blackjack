#!/usr/bin/env ruby
require 'sinatra'
require 'rerun'
require './lib/card.rb'
require './lib/deck.rb'
require './lib/hand.rb'
require './helpers/get_winner.rb'
require 'pp'

enable :sessions

helpers GetWinner

get '/' do
  deck = Deck.new
  deck.shuffle!

  player_hand = Hand.new
  player_hand.cards << deck.deal_card
  player_hand.cards << deck.deal_card
  dealer_hand = Hand.new
  dealer_hand.cards << deck.deal_card
  dealer_hand.cards << deck.deal_card

  session["player_hand"] = player_hand
  session["dealer_hand"] = dealer_hand
  session["deck"] = deck
  erb :index
end

get '/blackjack' do
  erb :blackjack, :locals => { :player_hand => session["player_hand"], :dealer_hand => session["dealer_hand"] }
end

get '/hit' do
  player_hand = session["player_hand"]
  deck = session["deck"]

  player_hand.cards << deck.deal_card

  session["player_hand"] = player_hand
  session["deck"] = deck

  if player_hand.value >= 21
    redirect to('/stay')
  else
    redirect to('/blackjack')
  end
end

get '/stay' do
  dealer_hand = session["dealer_hand"]
  player_hand = session["player_hand"]
  deck = session["deck"]

  until dealer_hand.value >= 17
    dealer_hand.cards << deck.deal_card
  end

  winning_message = winner(dealer_hand.value, player_hand.value)

  session["dealer_hand"] = dealer_hand
  session["deck"] = deck

  erb :stay, :locals => {
    :player_hand => session["player_hand"],
    :dealer_hand => session["dealer_hand"],
    :winning_message => winning_message }
end
