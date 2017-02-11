
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

get '/blackjack/hit' do
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  deck = load_the_deck
  save_dealer_hand(dealer_hand)
  save_player_hand(player_hand)
  erb :"blackjack/hit", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
end

post '/hit' do

  deck = load_the_deck
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  if checking_points(player_hand) > 21
    # save_the_deck(deck)
    dealer_hand << deal_hand(deck)
    save_dealer_hand(dealer_hand)
    save_player_hand(player_hand)
    # binding.pry
    erb :"blackjack/stay", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
    redirect to("/blackjack/stay")
    
  else
  # save_the_deck(deck)
    player_hand << deal_hand(deck)
    save_dealer_hand(dealer_hand)
    save_player_hand(player_hand)
    if checking_points(player_hand) >= 21
      erb :"blackjack/stay", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
      redirect to("/blackjack/stay")
    else
      erb :"blackjack/hit", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
    end
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

  # if checking_points(dealer_hand) < 17
  #   # save_the_deck(deck)
  #   dealer_hand << deal_hand(deck)
  #   save_dealer_hand(dealer_hand)
  #   save_player_hand(player_hand)
  #   erb :"blackjack/stay", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
    while checking_points(dealer_hand) < 17
      puts "DBG: dealer_hand iteration = #{dealer_hand.inspect}"
      dealer_hand << deal_hand(deck)
      # save_dealer_hand(dealer_hand)
      # save_player_hand(player_hand)
      # erb :"blackjack/stay", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
    end
    save_dealer_hand(dealer_hand)
    save_player_hand(player_hand)
    erb :"blackjack/results", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
    redirect to("/blackjack/results")
end

get '/blackjack/results' do
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  deck = load_the_deck
  erb :"blackjack/results", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
end

post '/new_game' do
  # save_dealer_hand(nil)
  # save_player_hand(nil)
  session.delete(:dealer_hand)
  session.delete(:player_hand)
  redirect to("/blackjack/hit")
end

