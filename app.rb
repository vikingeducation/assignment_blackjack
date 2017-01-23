require 'sinatra'
require './helpers/game.rb'

get '/blackjack' do
  gg = Game.new
  @dealer_pts = gg.dealer_pts
  @player_pts = gg.player_pts
  erb :blackjack
end