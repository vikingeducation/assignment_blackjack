require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/deck'
require './lib/hand'
require './lib/bank'
require './helpers/blackjack_helper'
require './helpers/sessions_helper'
require 'pry'
require 'json'

helpers BlackjackHelper, SessionsHelper

enable :sessions

get '/' do
  bank = session["bank"] ? load_bank : Bank.new.bank
  session.clear
  bank = save_bank(bank)

  erb :home, locals: { bank: bank }
end

get '/reset' do
  session.clear
  redirect to('/')
end

get '/blackjack' do
  if new_round?
    initialize_round
    game_over = true if Hand.new(load_player_hand).blackjack?
  else
    game_over = false
    load_round
  end

  erb :blackjack, locals: { deck: load_deck,
                            player_hand: load_player_hand,
                            dealer_hand: load_dealer_hand,
                            player_score: load_player_score,
                            dealer_score: load_dealer_score,
                            game_over: game_over,
                            bank: load_bank }
end


post '/blackjack/hit/:bet' do |bet|
  hit_player

  game_over = false
  game_over = true if Hand.new(load_player_hand).bust?

  erb :blackjack, locals: { deck: load_deck,
                            player_hand: load_player_hand,
                            dealer_hand: load_dealer_hand,
                            player_score: load_player_score,
                            dealer_score: load_dealer_score,
                            game_over: game_over,
                            bank: load_bank,
                            bet: bet.to_i }
end


get '/blackjack/dealer/:bet' do |bet|
  get_dealer_moves
  erb :blackjack, locals: { deck: load_deck,
                            player_hand: load_player_hand,
                            dealer_hand: load_dealer_hand,
                            player_score: load_player_score,
                            dealer_score: load_dealer_score,
                            game_over: true,
                            bank: load_bank,
                            bet: bet.to_i }
end




