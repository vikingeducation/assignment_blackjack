#!/usr/bin/env ruby
require 'sinatra'
require 'json'
enable :sessions

require './deck.rb'

# require './helpers/deck_helper.rb'

# helpers DeckHelper

get '/' do
  erb :home
end

get '/blackjack' do
  saved_deck = session[:deck].nil? ? nil : JSON.parse( session[:deck] )
  @deck = Deck.new(saved_deck).cards
  session[:deck] = @deck.to_json
  erb :blackjack
end