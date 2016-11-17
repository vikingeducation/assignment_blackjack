#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require './lib/deck.rb'

enable :sessions

get '/' do
  deck = Deck.new
  deck.shuffle!

  session["player_hand"] = [ deck.deal_card.to_s, deck.deal_card.to_s ]
  session["dealer_hand"] = [ deck.deal_card.to_s, deck.deal_card.to_s ]

  erb :index
end

get '/blackjack' do
  erb :blackjack, :locals => { :player_hand => session["player_hand"], :dealer_hand => session["dealer_hand"] }
end

get '/hit' do

  redirect to('/blackjack')
end

get '/stay' do

  redirect to('/blackjack')
end
