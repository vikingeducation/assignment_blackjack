#!/usr/bin/env ruby

require 'sinatra'
require 'erb'
require 'sinatra/reloader' if development?
require File.expand_path('./helpers/blackjack', File.dirname(__FILE__))

enable :sessions

helpers Blackjack

get '/' do
  erb :index
end

get '/blackjack' do

  # helper method?
  deck = Blackjack::Deck.new(cards: session['deck'])
  user_hand   = session['user_hand'] || deck.draw(2)
  dealer_hand = session['dealer_hand'] || deck.draw(2)

  user = Blackjack::User.new(hand: user_hand)
  dealer = Blackjack::Dealer.new(hand: dealer_hand)

  # helper method?
  session['deck'] = deck.cards
  session['user_hand'] = user_hand
  session['dealer_hand'] = dealer_hand

  erb :blackjack, locals: { user: user,
                            dealer: dealer,
                            params: params }
end

post '/blackjack' do

  if params[:hit]
    deck = Blackjack::Deck.new(cards: session['deck'])
    user = Blackjack::User.new(hand: session['user_hand'])
    user.hand.concat(deck.draw(1))
    session['user_hand'] = user.hand
  elsif params[:stay]
    session['stay'] = true
  end

  redirect to '/blackjack'
end

# get '/blackjack/hit'
# get '/blackjack/stay'
# post 'blackjack/stay'
# post 'blackjack/hit'
