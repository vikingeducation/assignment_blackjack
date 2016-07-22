require 'sinatra'
require 'erb'
require './blackjack.rb'
require './hand.rb'
require "sinatra/reloader" if development?
require 'pry'

get '/' do
  erb :index
end

get '/blackjack' do
  #unless request.cookies["deck"]
  #do you have deck if yes play with deck
  # if no create deck cookie that deck
  # deck passed
  if request.cookies["deck"]
    blackjack = Blackjack.new(request.cookies["deck"])
  else
    blackjack = Blackjack.new
  end
  if request.cookies["player_hand"]
    current_hand = Hand.new(blackjack.cards, request.cookies["player_hand"],request.cookies["dealer_hand"])
  else
    current_hand = Hand.new(blackjack.cards)
    current_hand.deal_cards
  end
  player_hand = current_hand.player_hand
  dealer_hand = current_hand.dealer_hand

  response.set_cookie("player_hand", player_hand)
  response.set_cookie("dealer_hand", dealer_hand)
  response.set_cookie("deck", blackjack.cards)
  binding.pry
  erb :blackjack, :locals =>{:dealer_hand => dealer_hand, :player_hand => player_hand }

end

post '/hit' do
  player_hand = request.cookies["player_hand"]
  dealer_hand = request.cookies["dealer_hand"]
  deck = request.cookies["deck"]
  blackjack = Blackjack.new(deck)
  current_hand = Hand.new(blackjack.cards, player_hand, dealer_hand)
  current_hand.player_hit(player_hand)
  response.set_cookie("player_hand", player_hand)
  response.set_cookie("deck", deck)
  redirect to('/blackjack')
end

