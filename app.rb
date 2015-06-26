require 'sinatra'
require './helpers/game_helper'

helpers GameHelper
enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do
  # shuffle cards
  if session[:deck].nil?
    deck = build_new_deck
  else
    deck = session[:deck]
  end

  # deal hands
  @player_hand, @dealer_hand = [0], [0]
  2.times do
    @player_hand << deck.pop
    @dealer_hand << deck.pop
  end


  # calc hands
  @player_hand[0] = calculate(@player_hand)
  @dealer_hand[0] = calculate(@dealer_hand)


  #save state
  session[:deck] = deck
  session[:player_hand] = @player_hand
  session[:dealer_hand] = @dealer_hand


  # render
  erb :blackjack
end


post '/blackjack/hit' do
  # load state
  deck = session[:deck]
  @player_hand = session[:player_hand]
  @dealer_hand = session[:dealer_hand]

  # add card to hand
  @player_hand << deck.pop

  # save state
  session[:deck] = deck
  session[:player_hand] = @player_hand

  # render
  erb :blackjack
end


post '/blackjack/stay' do
  # load state
  deck = session[:deck]
  @player_hand = session[:player_hand]
  @dealer_hand = session[:dealer_hand]

  # run dealer hand
  @dealer_hand << deck.pop

  # save state
  session[:deck] = deck
  session[:dealer_hand] = @dealer_hand

  # render
  erb :blackjack
end