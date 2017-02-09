
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

# get '/blackjack/game_view' do
#   deck = load_the_deck
#   dealer_hand = load_dealer_hand
#   player_hand = load_player_hand
#   # save_the_deck(deck)
#   save_dealer_hand(dealer_hand)
#   save_player_hand(player_hand)
#   erb :"blackjack/hit", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
# end

get '/blackjack/hit' do
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  deck = load_the_deck
  save_dealer_hand(dealer_hand)
  save_player_hand(player_hand)
  erb :"blackjack/hit", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
end

post '/hit' do
  # binding.pry
  deck = load_the_deck
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  if checking_points(player_hand) > 21
    # save_the_deck(deck)
    dealer_hand << deal_hand(deck)
    save_dealer_hand(dealer_hand)
    save_player_hand(player_hand)
    erb :"blackjack/stay", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
    redirect to("/blackjack/stay")
  else
    # save_the_deck(deck)
    player_hand << deal_hand(deck)
    save_dealer_hand(dealer_hand)
    save_player_hand(player_hand)
    erb :"blackjack/hit", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
  end
end

get '/blackjack/stay' do
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  deck = load_the_deck
  save_dealer_hand(dealer_hand)
  save_player_hand(player_hand)
  erb :"blackjack/stay", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
end

post '/stay' do
  deck = load_the_deck
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  # deck = load_the_deck
  if checking_points(dealer_hand) < 17
    # save_the_deck(deck)
    dealer_hand << deal_hand(deck)
    save_dealer_hand(dealer_hand)
    save_player_hand(player_hand)
    erb :"blackjack/stay", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
  else
    save_dealer_hand(dealer_hand)
    save_player_hand(player_hand)
    erb :"blackjack/results", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
    redirect to("/blackjack/results")
  end
end

get '/blackjack/results' do
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  deck = load_the_deck
  erb :"blackjack/results", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
  save_dealer_hand(nil)
  save_player_hand(nil)
end

post '/new_game' do
  save_dealer_hand(nil)
  save_player_hand(nil)
  erb :"blackjack/hit"
end

