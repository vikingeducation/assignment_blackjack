#!/usr/bin/env ruby
require 'sinatra'
require 'rerun'
require './lib/deck.rb'
require 'pp'

enable :sessions

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
  pp request
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

  redirect to('/blackjack')
end

get '/stay' do
  dealer_hand = session["dealer_hand"]
  deck = session["deck"]

  until dealer_hand.value >= 17
    dealer_hand.cards << deck.deal_card
  end

  session["dealer_hand"] = dealer_hand
  session["deck"] = deck

  redirect to('/blackjack')
end
