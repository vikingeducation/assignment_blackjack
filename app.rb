require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/blackjack.rb'

# dealer and player are each dealt 2 cards
# player can see their two cards, but only the 2nd card for the dealer
# session stores: bet amount, how much money they have, their hand, dealer's hand, deck





enable :sessions


get '/' do
  erb :index
end

get '/new' do
  blackjack = Blackjack.new
  dealer, player = blackjack.start_game
  erb :blackjack, :locals => { :dealer => dealer, :player => player}
end


get '/blackjack' do
  session[:players_hand] = 


  blackjack = Blackjack.new
  card = blackjack.deal_card
  erb :blackjack, :locals => { :card => card }
end