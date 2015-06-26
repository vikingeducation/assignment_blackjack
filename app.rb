require 'sinatra'
enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do
  # shuffle cards
  deck = ( (2..10).to_a.map {|n| n.to_s} + ["J","Q","K","A"] )*4
  deck.shuffle!

  # deal hands
  @player_hand, @dealer_hand = [], [
  ]
  2.times do
    @player_hand << deck.pop
    @dealer_hand << deck.pop
  end

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