require 'sinatra'
require "sinatra/reloader" if development?

require './blackjack.rb'
require './card_helper.rb'

helpers CardHelper
enable :sessions

get '/' do
  erb :index
end

post '/blackjack' do
  game = Blackjack.new
  game.new_hand
  player_hand = get_hand(game.player.hand)
  dealer_hand = get_hand(game.dealer.hand)
  p player_hand

  erb :blackjack, :locals => {:player_hand => player_hand, :dealer_hand => dealer_hand}
end
