#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/blackjack.rb'
require './helpers/card_saver.rb'
require 'pry-byebug'
# dealer and player are each dealt 2 cards
# player can see their two cards, but only the 2nd card for the dealer
# session stores: bet amount, how much money they have, their hand, dealer's hand, deck



helpers CardSaver

enable :sessions


get '/' do
  erb :index
end

get '/new' do
  blackjack = Blackjack.new
  dealer, player = blackjack.start_game

  save_hands(dealer, player)

  erb :blackjack, :locals => { :dealer => dealer, :player => player}
end

get '/blackjack' do
  sessions[:blackjack]

end

post '/blackjack/hit' do
  blackjack = Blackjack.new
  dealer = load_dealer
  player = load_player
  # binding.pry
  new_player = blackjack.hit(player)
  erb :blackjack, :locals => { :dealer => dealer, :player => new_player}

  save_hands(dealer, new_player)

end

post '/blackjack/stay' do

end

post '/blackjack/split' do

end