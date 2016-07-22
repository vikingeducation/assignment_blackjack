#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/contrib'
require 'deck'

enable :sessions

get '/' do 
  erb :home
end

get '/blackjack' do 

  erb :blackjack
end

# Deck class
  # #shuffle
  # deck is a hash of cards and number of each card remaining