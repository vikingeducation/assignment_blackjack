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
  blackjack = Blackjack.new(session[:deck])
  dealer, player = blackjack.start_game
  shoe = blackjack.get_shoe

  save_hands(dealer, player, shoe)

  erb :blackjack, :locals => { :dealer => dealer, :player => player}
end

get '/blackjack' do
  
  erb :blackjack, locals: { dealer: session[:dealer], player: session[:player], deck: session[:deck]}
end

post '/blackjack/hit' do
  blackjack = Blackjack.new(load_deck)
  dealer = load_dealer
  player = load_player
  new_player = blackjack.hit(player)
  save_hands(dealer, new_player, blackjack.get_shoe)

  redirect('/blackjack')
end

post '/blackjack/stay' do

end

post '/blackjack/split' do

end