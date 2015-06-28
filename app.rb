require 'sinatra'
require 'erb'
require './helpers/game_helper'
require './player.rb'
require './hand.rb'

helpers GameHelper
enable :sessions

get '/' do
  session.clear
  erb :home
end


get '/bet' do
  # start a new session
  if session[:player].nil?
    @player = Player.new
  else
    @player = session[:player]
  end


  invalid_bet = params[:invalid]

  # message if redirected here
  save_game_state(@player)

  erb :bet, :locals => { :invalid => invalid_bet }
end

post '/bet' do
  @player = session[:player]

  bet = params[:bet_amount].to_i

  if @player.valid_bet?(bet)
    # start a new hand
    @hand = Hand.new(bet)
    @player.bankroll -= bet
    save_game_state(@player, @hand)
    redirect to('/blackjack')
  else
    redirect '/bet?invalid=true'
  end

end


get '/blackjack' do
  # load state
  @player = session[:player]
  @hand = session[:hand]


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


  @hand.win_message = declare_winner(@hand.hands[:player][0], @hand.hands[:dealer][0])

  @player.payoff!(@hand.bet, @hand.win_message)

  save_game_state(@player, @hand)

  erb :blackjack, :locals => { :player_turn => false }
end