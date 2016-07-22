#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/contrib'
require_relative 'deck'
require_relative 'blackjack'
require_relative 'player'
require_relative 'dealer'

enable :sessions

get '/' do 
  erb :home
end

get '/blackjack' do
  game = Blackjack.new
  game.start
  sessions['deck'] = game.deck.cards
  sessions['player_hand'] = game.player.hand
  sessions['dealer_hand'] = game.dealer.hand
  
  erb :blackjack
end

# Deck class
  # #shuffle
  # deck is a hash of cards and number of each card remaining