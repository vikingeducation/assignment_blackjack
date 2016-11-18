#!/usr/bin/env ruby
require 'sinatra'
require 'rerun'
require './lib/card.rb'
require './lib/deck.rb'
require './lib/hand.rb'
require './helpers/get_winner.rb'
require 'pp'

enable :sessions

helpers GetWinner

get '/' do
  bankroll = 1000

  session["bankroll"] = bankroll
  erb :index
end

get '/bet' do
  bankroll = session['bankroll']
  insufficient = params[:insufficient]

  deck = Deck.new
  deck.shuffle!
  player_hand = Hand.new
  player_hand.cards << deck.deal_card
  player_hand.cards << deck.deal_card
  dealer_hand = Hand.new
  dealer_hand.cards << deck.deal_card
  dealer_hand.cards << deck.deal_card

  session["player_hand"] = player_hand
  session["dealer_hand"] = dealer_hand
  session["deck"] = deck
  erb :bet, :locals => { :bankroll => bankroll, :insufficient => insufficient }
end

post '/bet' do
  bet = params[:bet]

  if bet.to_i > session['bankroll'].to_i
    redirect to('/bet?insufficient=true')
  else
    session['bet'] = bet
    erb :blackjack, :locals => { :bet => bet }
  end
end

get '/blackjack' do
  erb :blackjack, :locals => { :player_hand => session["player_hand"], :dealer_hand => session["dealer_hand"] }
end

get '/hit' do
  player_hand = session["player_hand"]
  deck = session["deck"]

  player_hand.cards << deck.deal_card

  session["player_hand"] = player_hand
  session["deck"] = deck

  if player_hand.value >= 21
    redirect to('/stay')
  else
    redirect to('/blackjack')
  end
end

get '/stay' do
  dealer_hand = session["dealer_hand"]
  player_hand = session["player_hand"]
  deck = session["deck"]
  bankroll = session["bankroll"].to_i
  bet = session['bet'].to_i

  until dealer_hand.value >= 17
    dealer_hand.cards << deck.deal_card
  end

  winning_player = winner(dealer_hand, player_hand)
  winning_message = get_winning_message(winning_player, dealer_hand, player_hand)

  if winning_player == :player
    bankroll += bet
  elsif winning_player == :dealer
    bankroll -= bet
  end

  session["dealer_hand"] = dealer_hand
  session["deck"] = deck
  session["bankroll"] = bankroll

  erb :stay, :locals => {
    :player_hand => session["player_hand"],
    :dealer_hand => session["dealer_hand"],
    :winning_message => winning_message,
    :bankroll => bankroll
  }
end
