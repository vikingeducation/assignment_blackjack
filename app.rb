#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require './lib/deck.rb'

get '/' do
  erb :index
end

get '/blackjack' do

  deck = Deck.new

  @player_hand = deck.deal_card
  dealer_hand = []

  erb :blackjack, :locals => { :player_hand => @player_hand }
end
