#!/usr/bin/env ruby
require 'sinatra'
require 'rerun'
require './lib/deck.rb'

enable :sessions

get '/' do
  deck = Deck.new
  deck.shuffle!

  session["player_hand"] = [ deck.deal_card.to_s, deck.deal_card.to_s ]
  session["dealer_hand"] = [ deck.deal_card.to_s, deck.deal_card.to_s ]
  session["deck"] = deck
  erb :index
end

get '/blackjack' do
  erb :blackjack, :locals => { :player_hand => session["player_hand"], :dealer_hand => session["dealer_hand"] }
end

get '/hit' do
  session["player_hand"] << session["deck"].deal_card.to_s
  redirect to('/blackjack')
end

get '/stay' do

  redirect to('/blackjack')
end
