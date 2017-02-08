
require 'erb'
require 'pry-byebug'
require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/bj_helper.rb'
require 'json'

helpers BJHelper

enable :sessions

get "/" do
  erb :home
end

get '/blackjack/game_view' do
  # binding.pry
  deck = load_the_deck
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  puts "DBG: session[:dealer_hand] = #{session[:dealer_hand].inspect}"
  puts "DBG: session[:deck] = #{session[:deck].inspect}"
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
    puts "DBG: session[:dealer_hand] = #{session[:dealer_hand].inspect}"
  puts "DBG: session[:player_hand] = #{session[:player_hand].inspect}"
  puts "DBG: session[:deck] = #{session[:deck].inspect}"
  if checking_points(player_hand)[0] > 21
    save_the_deck(params[:deck])
    save_dealer_hand(params[:dealer_hand])
    save_player_hand(params[:player_hand])
    redirect to("/blackjack/stay")
  else
   save_the_deck(params[:deck])
    save_dealer_hand(params[:dealer_hand])
    save_player_hand(params[:player_hand])
    redirect to("blackjack/hit")
  end
end

get '/blackjack/hit' do
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  deck = load_the_deck
  puts "DBG: player_handin get /hit  = #{player_hand.inspect}"
  puts "DBG: dealer_handin get /hit  = #{dealer_hand.inspect}"
  puts "DBG: deckin get /hit  = #{deck.inspect}"
  erb :"blackjack/hit", locals: { deck: deck, dealer_hand: dealer_hand, player_hand: player_hand }
end

get '/blackjack/stay' do
  dealer_hand = load_dealer_hand
  player_hand = load_player_hand
  deck = load_the_deck
  erb :"blackjack/stay"
end

post '/stay' do
  deck = save_the_deck(params[:deck])
  dealer_hand = save_dealer_hand(params[:dealer_hand])
  player_hand = save_player_hand(params[:player_hand])
  if checking_points(dealer_hand)[0] < 17
    redirect to("/blackjack/stay")
  else
    redirect to ('/blackjack/game_view')
  end
end





