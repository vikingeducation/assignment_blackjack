require 'sinatra'
require 'erb'
require './blackjack.rb'
require "sinatra/reloader" if development?

get '/' do
  erb :index
end

get '/blackjack' do
  #unless request.cookies["deck"]
  #do you have deck if yes play with deck
  # if no create deck cookie that deck
  # deck passed






  blackjack = Blackjack.new
  deck = blackjack
  cards = blackjack.deal_to_players(2)
  player_hand = cards[0]
  dealer_hand = cards[1]
  response.set_cookie("player_hand", player_hand)
  response.set_cookie("dealer_hand", dealer_hand)
  response.set_cookie("deck", deck)
  erb :blackjack, :locals =>{:dealer_hand => dealer_hand, :player_hand => player_hand }

end

post '/hit' do
  player_hand = request.cookies["player_hand"]
  deck = request.cookies["deck"]
  new_card = deck.pop
  player_hand << new_card
  response.set_cookie("player_hand", player_hand)
  response.set_cookie("deck", deck)
  redirect to('/blackjack')
end

