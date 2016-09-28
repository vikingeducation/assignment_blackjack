require 'sinatra'
require 'erb'
require_relative 'helpers/blackjack_helper.rb'

enable :sessions
helpers DeckHelper


get '/' do
  erb :home
end

post '/blackjack' do
  create_deck
  new_hand
  if player_blackjack? || dealer_blackjack?
    redirect '/blackjack/stay'
  else
    erb :blackjack
  end
end

post '/blackjack/hit' do
  player_hit
  if player_busted?
    redirect '/blackjack/stay'
  else
    erb :blackjack
  end
end

post '/blackjack/stay' do
  if !dealer_busted?
    while dealer_total < 17
      dealer_hit
    end
  end
  redirect '/blackjack/stay'
end

get '/blackjack/stay' do
  compare_hands
  erb :gameover
end