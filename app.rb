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
  session.clear
  erb :index
end

get '/bet' do
  erb :bet, :locals => { 'redirect' => session['redirect_message']}
end

post '/bet' do
  player = Player.new(session['player'])
  player.bet = params[:bet].to_i
  if player.bank < player.bet
    session['redirect_message'] = "Sorry, you don't have that much money (yet)! Please enter a different amount:"
    redirect '/bet'
  end
  save_player('player', player)
  redirect '/blackjack'
end

get '/blackjack' do
  deck = Deck.new(session['deck'])
  player = Player.new(session['player'])
  dealer = AI.new(session['dealer'])
  deck.deal(player, dealer) unless session['on']

  session['on'] = true
  save_player('dealer', dealer)
  save_player('player', player)
  save_deck(deck)
  erb :blackjack, :locals => {'deck' => deck, 'dealer' => dealer, 'player' => player, 'game_over' => session[:game_over]}
end

post '/blackjack/hit' do
  deck = Deck.new(session['deck'])
  player = Player.new(session['player'])
  deck.hit(player)

  save_deck(deck)
  save_player('player', player)
  redirect to("/blackjack/stay") if player.sum > 21
  redirect to('/blackjack')
end

get '/blackjack/stay' do
  dealer = AI.new(session['dealer'])
  deck = Deck.new(session['deck'])
  player = Player.new(session['player'])
  deck.hit(dealer) until dealer.enough?
  deck.settle_winnings(player, dealer)
  save_player('player', player)
  session['game_over'] = true
  save_player('dealer', dealer)
  redirect '/blackjack'
end
