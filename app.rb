require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'erb'
require_relative 'lib/player'
require_relative 'lib/deck'
require './helpers/savers'

enable :sessions

helpers Savers

get '/' do
  erb :index
end

get '/blackjack' do
  deck = Deck.new(session['deck'])
  player = Player.new(session['player'])
  dealer = AI.new(session['dealer'])
  deck.deal(player, dealer) unless session['on']

  session['on'] = true
  save_hand('dealer', dealer)
  save_hand('player', player)
  save_deck(deck)
  erb :blackjack, :locals => {'deck' => deck, 'dealer' => dealer, 'player' => player, 'game_over' => session[:game_over]}
end

post '/blackjack/hit' do
  deck = Deck.new(session['deck'])
  player = Player.new(session['player'])
  deck.hit(player)

  save_deck(deck)
  save_hand('player', player)
  redirect to("/blackjack/stay") if player.sum > 21
  redirect to('/blackjack')
end

get '/blackjack/stay' do
  dealer = AI.new(session['dealer'])
  deck = Deck.new(session['deck'])
  deck.hit(dealer) until dealer.enough?

  session['game_over'] = true
  save_deck(deck)
  save_hand('dealer', dealer)
  redirect '/blackjack'
end

get '/blackjack/restart' do
  session.clear
  redirect '/'
end
