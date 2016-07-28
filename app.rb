require 'sinatra'
require 'erb'
require 'pry-byebug'
require './helpers/deck_helpers.rb'
helpers DeckHelper
enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  create_deck
  erb :blackjack
end

post '/blackjack/hit' do
  deal_player
  if player_busted?
    redirect "/blackjack/stay"
  else
    erb :blackjack
  end
end

post '/blackjack/stay' do
  if !player_busted?
    while dealer_count < 17
      deal_dealer
    end
  end
  redirect "/blackjack/stay"
end

get '/blackjack/stay' do
  @winner = compare_hands
  @busted = busted_player
  erb :gameover
end