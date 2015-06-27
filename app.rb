require 'sinatra'
require 'erb'
require './helpers/game_helper'
require './player.rb'

helpers GameHelper
enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do

  @win_message = ""
  deck = build_new_deck

  # deal hands
  @player_hand, @dealer_hand = [0], [0]
  2.times do
    @player_hand << deck.pop
    @dealer_hand << deck.pop
  end

  # calc hands
  @player_hand[0] = calculate(@player_hand)
  @dealer_hand[0] = calculate(@dealer_hand)

  save_game_state(deck, @player_hand, @dealer_hand, @win_message)

  # check blackjacks
  redirect '/blackjack/stay', 307 if @player_hand == 21 || @dealer_hand[0] == 21

  # render
  erb :blackjack, :locals => { :player_turn => true }
end


post '/blackjack/hit' do
  # load state
  deck = session[:deck]
  @player_hand = session[:player_hand]
  @dealer_hand = session[:dealer_hand]

  # add card to hand
  @player_hand << deck.pop

  # calc hands
  @player_hand[0] = calculate(@player_hand)
  @dealer_hand[0] = calculate(@dealer_hand)

  save_game_state(deck, @player_hand, @dealer_hand, @win_message)

  # if bust, go to /stay
  redirect '/blackjack/stay', 307 if @player_hand[0] >= 21

  # render
  erb :blackjack, :locals => { :player_turn => true }
end


post '/blackjack/stay' do
  # buttons need to disappear

  # load state
  deck = session[:deck]
  @player_hand = session[:player_hand]
  @dealer_hand = session[:dealer_hand]


  # reveal dealer card

  # decide hit/stay
  if @player_hand[0] <= 21
    while @dealer_hand[0] < 17
      @dealer_hand << deck.pop
      @dealer_hand[0] = calculate(@dealer_hand)
    end
  end

  save_game_state(deck, @player_hand, @dealer_hand, @win_message)

  @win_message = declare_winner(@player_hand[0], @dealer_hand[0])

  # render with win/loss
  erb :blackjack, :locals => { :player_turn => false }
end