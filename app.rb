require 'sinatra'
require 'thin'
require 'byebug'
require 'pp'
require 'json'
# require 'sinatra/reloader' if development?
require './helpers/blackjack'

enable :sessions

get '/' do
  erb :index
end

get '/blackjack' do
  game = Blackjack.new
  session['player_deck'] = game.player_cards.to_json
  session['dealer_deck'] = game.dealer_cards.to_json
  session['main_deck'] = game.deck.to_json

end