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
  game = Blackjack.new(session['deck'], session['player_hand'], session['dealer_hand'])
  if params[:hit] 
    game.player.hit(game.deck.cards)
  else 
    game.dealer.hit(game.deck.cards)
  end
  session['deck'] = game.deck.cards
  session['player_hand'] = game.player.hand
  session['dealer_hand'] = game.dealer.hand

  erb :blackjack
end

# Deck class
  # #shuffle
  # deck is a hash of cards and number of each card remaining