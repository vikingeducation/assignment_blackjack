#!/usr/bin/env ruby

require 'sinatra'
require 'thin'
require 'pry-byebug'
require 'sinatra/reloader' if development?

also_reload 'lib/*'

enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  if session[:player_hand]
    @blackjack = load_session
  else
    @blackjack = new_game
  end
  @test = session[:status]
  erb :game
end

post '/blackjack/hit' do
  player_hand = Hand.deserialize(session[:player_hand])
  dealer_hand = Hand.deserialize(session[:dealer_hand])
  @blackjack = Blackjack.new(player_hand, dealer_hand)
  @blackjack.deal(@blackjack.player_hand)
  session[:player_hand] = @blackjack.player_hand.serialize
  session[:dealer_hand] = @blackjack.dealer_hand.serialize
  session[:status] = "hit"
  redirect '/blackjack'
end

post '/blackjack/stay' do
  session[:status] = "stay"
  redirect '/blackjack'
end

post '/blackjack/split' do
  redirect '/blackjack'
end

post '/blackjack/double' do
  redirect '/blackjack'
end
