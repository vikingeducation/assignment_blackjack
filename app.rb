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
  session['deck'] = game.deck.cards
  session['player_hand'] = game.player.hand
  session['dealer_hand'] = game.dealer.hand
  
  erb :blackjack
end

post '/turn' do 
  Blackjack.new.deck = session[:deck]
  if params[:hit] 
    session['player_hand']
  elsif params[:stay]

  end

end

# Deck class
  # #shuffle
  # deck is a hash of cards and number of each card remaining