#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/blackjack.rb'
require './helpers/card_saver.rb'
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


post '/blackjack' do
  erb :blackjack
end

post '/hit' do
  
end

post '/stay' do

end

post '/split' do

end