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

  erb :blackjack, :locals => { :dealer => dealer, :player => player, :deck => shoe}
end

get '/blackjack' do
  erb :blackjack, locals: { dealer: session[:dealer], player: session[:player], deck: session[:deck]}
end


get '/loss' do
  erb :loss, locals: { dealer: session[:dealer], player: session[:player] }
end

get '/win' do
  erb :win, locals: { dealer: session[:dealer], player: session[:player]}
end

get '/tie' do
  erb :tie, locals: { dealer: session[:dealer], player: session[:player]}
end


post '/blackjack/hit' do
  blackjack = Blackjack.new(load_deck)
  dealer = load_dealer
  player = load_player
  new_player = blackjack.hit(player)
  save_hands(dealer, new_player, blackjack.get_shoe)

  if blackjack.bust?(new_player)
    redirect('/loss')
  else
    redirect('/blackjack')
  end

end

post '/blackjack/stay' do
  blackjack = Blackjack.new(load_deck)
  new_dealer = blackjack.dealer_hit(session[:dealer])
  save_hands(new_dealer, session[:player], session[:deck])

  if blackjack.bust?(new_dealer)
    redirect('/win')
  else
    outcome = blackjack.outcome(new_dealer, session[:player])
    redirect("/#{outcome}")
  end
end

post '/blackjack/split' do

end