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

  deck = Blackjack::Deck.new

  user_hand = session['user_hand'] || []
  dealer_hand = session['dealer_hand'] || []

  # user = Blackjack::User.new(hand: user_hand)
  # dealer = Blackjack::Dealer.new(hand: dealer_hand)

  user = ""
  dealer = ""

  erb :blackjack, locals: { user: user,
                            dealer: dealer,
                            deck: deck }
end
