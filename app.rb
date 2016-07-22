require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require './classes/blackjack'
# also_reload './views'

helpers BlackjackHelper
enable :sessions

get '/' do
  "<h1>Welcome!</h1><br><a href='/blackjack'>Play blackjack!</a>"
end

get '/blackjack' do
  player_hand = get_player_hand
  dealer_hand = get_dealer_hand
  erb :blackjack, locals: { player_hand: player_hand, dealer_hand: dealer_hand }
end

post '/blackjack/hit' do
  # add_card
  get_player_hand
  redirect ('blackjack')
end

post '/blackjack/stay' do

  redirect ('blackjack')
end
