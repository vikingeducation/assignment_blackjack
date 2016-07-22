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
  @game = make_blackjack
  erb :blackjack, locals: { player_hand: get_player_hand, dealer_hand: get_dealer_hand }
end

post '/blackjack/hit' do
  @game = make_blackjack
  @game.give_card(@game.player_hand)
  #check for end
  save_game(@game)

  # add_card
  
  redirect ('blackjack')
end

post '/blackjack/stay' do

  redirect ('blackjack')
end
