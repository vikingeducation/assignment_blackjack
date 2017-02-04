
require 'erb'
require 'pry-byebug'
require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/bj_helper.rb'

helpers BJHelper

enable :sessions

get "/" do
  erb :home
end

get '/blackjack/game_view' do
  @deck = load_the_deck
  @dealer_hand = [deal_hand(@deck), deal_hand(@deck)]
  @player_hand = [deal_hand(@deck), deal_hand(@deck)]
  puts "DBG: @player_hand = #{@player_hand.inspect}"
  erb :"blackjack/game_view"
end

post '/hit' do
  puts "DBG: @player_hand = #{@player_hand.inspect}"
  if checking_points(@player_hand)[0] > 21
    redirect to("/blackjack/stay")
  else
    @deck = save_the_deck(params[:deck])
    @dealer_hand = save_dealer_hand(params[:dealer_hand])
    @player_hand = save_player_hand(params[:player_hand])
    redirect to("blackjack/hit")
  end
end

get '/blackjack/hit' do
  @dealer_hand = load_dealer_hand
  @player_hand = load_player_hand
  @deck = load_the_deck
  puts "DBG: @player_handin get /hit  = #{@player_hand.inspect}"
  puts "DBG: @dealer_handin get /hit  = #{@dealer_hand.inspect}"
  puts "DBG: @deckin get /hit  = #{@deck.inspect}"
  erb :"blackjack/hit"
end

get '/blackjack/stay' do
  @dealer_hand = load_dealer_hand
  @player_hand = load_player_hand
  @deck = load_the_deck
  erb :"blackjack/stay"
end

post '/stay' do
  @deck = save_the_deck(params[:deck])
  @dealer_hand = save_dealer_hand(params[:dealer_hand])
  @player_hand = save_player_hand(params[:player_hand])
  if checking_points(@dealer_hand)[0] < 17
    redirect to("/blackjack/stay")
  else
    redirect to ('/blackjack/game_view')
  end
end





