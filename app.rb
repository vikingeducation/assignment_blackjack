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

  # set up game and read game state
  deck = Blackjack::Deck.new(cards: session['deck'])
  user_hand   = session['user_hand'] || deck.draw(2)
  dealer_hand = session['dealer_hand'] || deck.draw(2)

  # updat user initialization to include betting pool
  user = Blackjack::User.new(hand: user_hand)
  dealer = Blackjack::Dealer.new(hand: dealer_hand,
                                 deck: deck,
                                 opponent: user)

  # update game state
  session['deck'] = deck.cards
  session['dealer_hand'] = dealer_hand
  session['user_bet'] = session['user_bet'].to_i || 500
  session['user_cash'] = (session['user_cash'].to_i - session['user_bet']) || 9500
  session['user_hand'] = user_hand

  # if user stays
  if session['stay']
    dealer.hit
    session['stay'] = false
  end

  # check for bust
  if user.bust? || dealer.bust?
    session['user_hand'] = nil
    session['dealer_hand'] = nil
    session['deck'] = nil
  end

  erb :blackjack, locals: { user: user,
                            dealer: dealer }
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
