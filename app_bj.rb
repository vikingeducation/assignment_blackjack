
require 'erb'
require 'pry-byebug'
require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/bj_helper.rb'
require 'json'

helpers BJHelper

enable :sessions
set :session_secret, '*&(^B234'

get "/" do
  erb :home
end

get '/blackjack/game_view' do
  # binding.pry
  deck = load_the_deck
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  save_the_deck(deck)
  save_dealer_hand(dealer_hand)
  save_player_hand(player_hand)
  erb :"blackjack/game_view", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
end

get '/clear_session' do
  session.clear
  redirect to("/")
end

post '/hit' do
  deck = load_the_deck
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  if checking_points(player_hand)[0] > 21
    save_the_deck(deck)
    save_dealer_hand(dealer_hand)
    save_player_hand(player_hand)
    redirect to("/blackjack/stay")
  else
    save_the_deck(deck)
    save_dealer_hand(dealer_hand)
    save_player_hand(player_hand)
    redirect to("blackjack/hit")
  end
end

get '/blackjack/hit' do
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  deck = load_the_deck
  erb :"blackjack/hit", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
end

get '/blackjack/stay' do
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  deck = load_the_deck
  erb :"blackjack/stay"
end

post '/stay' do
  deck = save_the_deck(:deck)
  dealer_hand = save_dealer_hand(dealer_hand)
  player_hand = save_player_hand(player_hand)
  if checking_points(dealer_hand)[0] < 17
    redirect to("/blackjack/stay")
  else
    redirect to ('/blackjack/game_view')
  end
end





