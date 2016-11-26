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
  user = Blackjack::User.new(hand: user_hand,
                             money: session['user_cash'])
  dealer = Blackjack::Dealer.new(hand: dealer_hand,
                                 deck: deck,
                                 opponent: user)

  # update game state
  session['deck']        = deck.cards
  session['dealer_hand'] = dealer_hand
  session['user_bet']    = session['user_bet'] || 500
  session['user_hand']   = user_hand

  # updates betting pool
  unless session['disabled']
    session['user_cash']   = (user.betting_pool - session['user_bet'].to_i)
    user.betting_pool      = session['user_cash']
  end

  # if user stays
  if session['stay']
    dealer.hit
    session['stay'] = false
  end

  # check for bust
  if user.bust? || dealer.bust?
    if dealer.bust?
      user.betting_pool += (session['user_bet'].to_i * 2)
      session['user_cash'] = user.betting_pool
    end
    session['bet']         = nil
    session['dealer_hand'] = nil
    session['deck']        = nil
    session['disabled']    = nil
    session['user_hand']   = nil
  end



  erb :blackjack, locals: { bet: session['user_bet'].to_i,
                            user: user,
                            dealer: dealer,
                            disabled: session['disabled'] }
end

post '/blackjack' do

  if params[:hit]
    deck = Blackjack::Deck.new(cards: session['deck'])
    user = Blackjack::User.new(hand: session['user_hand'])
    user.hand.concat(deck.draw(1))
    session['user_hand'] = user.hand
    session['disabled']  = 'disabled'
    session['user_bet']  = params[:bet]
  elsif params[:stay]
    session['stay']      = true
    session['disabled']  = 'disabled'
  end

  redirect to '/blackjack'
end

# get '/blackjack/hit'
# get '/blackjack/stay'
# post 'blackjack/stay'
# post 'blackjack/hit'
