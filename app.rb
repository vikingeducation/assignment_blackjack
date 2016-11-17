#!/usr/bin/env ruby
require 'sinatra'
require 'rerun'
require './lib/deck.rb'
require 'pp'

enable :sessions

helpers do

  def winner(dealer_hand, player_hand)
    dealer_score = prox_twenty_one(dealer_hand)
    player_score = prox_twenty_one(player_hand)

    return "TIE!!!" if player_score < 1 && dealer_score < 1
    return "TIE!!!" if player_score == dealer_score

    return "Dealer busts Player wins" if dealer_score < 0
    return "You bust, I win" if player_score < 0

    if player_score < dealer_score
      "You Win!!! Congratulations!"
    else
      "I Win!! Your money is mine!!"
    end
  end

  def prox_twenty_one(hand_score)
    if hand_score > 21
      -1
    else
      21 - hand_score
    end
  end
end

get '/' do
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
  pp request
  erb :index
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

  until dealer_hand.value >= 17
    dealer_hand.cards << deck.deal_card
  end

  winning_message = winner(dealer_hand.value, player_hand.value)

  session["dealer_hand"] = dealer_hand
  session["deck"] = deck

  erb :stay, :locals => {
    :player_hand => session["player_hand"],
    :dealer_hand => session["dealer_hand"],
    :winning_message => winning_message }
end
