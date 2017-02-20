require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'erb'
require_relative 'lib/player'
require_relative 'lib/deck'
require './helpers/sessions'

enable :sessions

helpers Sessions

get '/' do
  player = load_player(session['player']) if session['player']
  session.clear
  set_up_player(player) if player
  erb :index
end

get '/bet' do
  bank = session['player'] ? Player.new(session['player']).bank : 1000
  erb :bet, :locals => { 'redirect' => session['redirect_message'], 'bank' => bank}
end

post '/bet' do
  player = Player.new(session['player'])
  player.bet = params[:bet].to_i
  if player.bank < player.bet
    session['redirect_message'] = "Sorry, you only have $#{player.bank}<br> Please enter a different amount:<br>"
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
  if dealer.blackjack? || player.blackjack?
    deck.settle_winnings(player, dealer)
    session['game_over'] = true
  end

  session['on'] = true
  save_player('dealer', dealer)
  save_player('player', player)
  save_deck(deck)
  erb :blackjack, :locals => {'deck' => deck, 'dealer' => dealer, 'player' => player, 'game_over' => session[:game_over], 'double' => session[:double]}
end

post '/blackjack/hit' do
  deck = Deck.new(session['deck'])
  player = Player.new(session['player'])
  deck.hit(player)
  save_deck(deck)
  save_player('player', player)
  redirect "/blackjack/stay" if player.sum > 21 || session['double']
  redirect '/blackjack'
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

post '/blackjack/double' do
  session['double'] = true
  deck = Deck.new(session['deck'])
  player = Player.new(session['player'])
  deck.hit(player)
  save_deck(deck)
  player.bet *= 2
  save_player('player', player)
  redirect to("/blackjack/stay")
end
