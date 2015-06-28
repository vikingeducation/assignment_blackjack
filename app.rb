require 'sinatra'
require 'erb'
require './helpers/game_helper'
require './helpers/session_helper'
require './player.rb'
require './hand.rb'

helpers GameHelper, SessionHelper
enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do

  # start a new session
  if session[:player].nil?
    @player = Player.new
  else
    @player = session[:player]
  end

  # get player bet
  bet = 50


  # start a new hand
  @hand = Hand.new(bet)


  @hand.calc_hand_values!


  save_game_state(@player, @hand)

  # check blackjacks -- BROKEN!!!
  # redirect '/blackjack/stay', 307 if @player_hand == 21 || @dealer_hand[0] == 21

  erb :blackjack, :locals => { :player_turn => true }
end


post '/blackjack/hit' do
  # load state
  @player = session[:player]
  @hand = session[:hand]

  # add card to hand
  @hand.hands[:player] << @hand.deck.pop

  @hand.calc_hand_values!

  save_game_state(@player, @hand)

  # if bust, go to /stay
  redirect '/blackjack/stay', 307 if @hand.hands[:player][0] >= 21

  # render
  erb :blackjack, :locals => { :player_turn => true }
end


post '/blackjack/stay' do

  # load state
  @player = session[:player]
  @hand = session[:hand]


  # decide hit/stay
  if @hand.hands[:player][0] <= 21
    @hand.dealer_plays!
  end

  save_game_state(@player, @hand)

  @hand.win_message = declare_winner(@hand.hands[:player][0], @hand.hands[:dealer][0])

  # update bankroll

  erb :blackjack, :locals => { :player_turn => false }
end