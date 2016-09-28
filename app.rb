require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'

require './helpers/blackjack_helper.rb'
require './public/assets/carddeck.rb'
require './public/assets/player.rb'

helpers BlackjackHelper

enable :sessions

get '/blackjack' do
  @deck = load_deck
  #@player = load_player
  #@dealer = load_player

  save_deck(@deck)
  #save_player(@player)
  #save_dealer(@dealer)

  erb :"blackjack.html"
end