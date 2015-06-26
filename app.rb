require 'sinatra'


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

  # render
  erb :blackjack
end