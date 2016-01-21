require 'sinatra'
require 'thin'
require 'byebug'
require 'pp'
require 'json'
# require 'sinatra/reloader' if development?
require './helpers/blackjack'

enable :sessions

get '/' do
  game = Blackjack.new
  session['player_deck'] = game.player_cards.to_json
  session['dealer_deck'] = game.dealer_cards.to_json
  session['main_deck'] = game.deck.to_json

  erb :index

end

post '/' do
  redirect to('/blackjack')
end

get '/blackjack' do
  player_deck = JSON.parse( session[:player_deck] )
  erb :blackjack, :locals => {:player_deck => player_deck}
end