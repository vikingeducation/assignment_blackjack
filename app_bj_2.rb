
require 'erb'
require 'pry-byebug'
require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require './helpers/bj_helper_2.rb'
require 'json'

helpers BJHelper

enable :sessions
set :session_secret, '*&(^B234'

get "/" do
  erb :home
end

get '/blackjack/bet' do
  dealer_hand = BJHelper::Dealer.new(session[:dealer_hand]).load_dealer_hand
  player = BJHelper::Player.new(session[:player_hand], session[:player_bankroll])
  player_bankroll = player.bankroll
  player_hand = player.load_player_hand
  session[:player_bankroll] = player_bankroll.to_json
  session[:dealer_hand] = dealer_hand.to_json
  session[:player_hand] = player_hand.to_json
  erb :"blackjack/bet", locals: { player_bankroll: player_bankroll }
end

post '/bet' do
  dealer_hand = BJHelper::Dealer.new(session[:dealer_hand]).load_dealer_hand
  player = BJHelper::Player.new(session[:player_hand], session[:player_bankroll])
  player_bankroll = player.bankroll
  player_hand = player.load_player_hand
  player_bet = params[:amount].to_i
  if player_bet < player_bankroll
    session[:dealer_hand] = dealer_hand.to_json
    session[:player_hand] = player_hand.to_json
    player_bankroll = (player_bankroll - player_bet)
    session[:player_bankroll] = player_bankroll.to_json
    session[:player_bet] = player_bet.to_json
    erb :"blackjack/hit", locals: { player_bet: player_bet, player_bankroll: player_bankroll, dealer_hand: dealer_hand, player_hand: player_hand }
  else
    player_bet = 0
    session[:player_bet] = player_bet.to_json
    erb :"blackjack/bet", locals: { player_bet: player_bet, player_bankroll: player_bankroll, dealer_hand: dealer_hand, player_hand: player_hand }
  end
end

get '/blackjack/hit' do
  dealer_hand = BJHelper::Dealer.new(session[:dealer_hand]).load_dealer_hand
  player = BJHelper::Player.new(session[:player_hand], session[:player_bankroll])
  player_bankroll = player.bankroll
  player_hand = player.load_player_hand
  player_bet = session[:player_bet]
  session[:dealer_hand] = dealer_hand.to_json
  session[:player_hand] = player_hand.to_json
  session[:player_bankroll] = player_bankroll.to_json
  erb :"blackjack/hit", locals: { player_bet: player_bet, player_bankroll: player_bankroll, dealer_hand: dealer_hand, player_hand: player_hand }
end

post '/hit' do
  dealer_hand = BJHelper::Dealer.new(session[:dealer_hand]).load_dealer_hand
  player = BJHelper::Player.new(session[:player_hand], session[:player_bankroll])
  player_bankroll = player.bankroll
  player_hand = player.load_player_hand
  player_bet = session[:player_bet]
  deck = BJHelper::Deck.new
  if deck.checking_points(player_hand) >= 21
    dealer_hand << deck.deal_hand
    session[:dealer_hand] = dealer_hand.to_json
    session[:player_hand] = player_hand.to_json
    session[:player_bankroll] = player_bankroll.to_json
    erb :"blackjack/stay", locals: { player_bet: player_bet, player_bankroll: player_bankroll,dealer_hand: dealer_hand, player_hand: player_hand }
    redirect to("/blackjack/stay")
  else
    player_hand << deck.deal_hand
    session[:dealer_hand] = dealer_hand.to_json
    session[:player_hand] = player_hand.to_json
    session[:player_bankroll] = player_bankroll.to_json
    if deck.checking_points(player_hand) >= 21
      erb :"blackjack/stay", locals: { player_bet: player_bet, player_bankroll: player_bankroll,dealer_hand: dealer_hand, player_hand: player_hand }
      redirect to("/blackjack/stay")
    else
      erb :"blackjack/hit", locals: { player_bet: player_bet, player_bankroll: player_bankroll,dealer_hand: dealer_hand, player_hand: player_hand }
    end
  end
end

get '/blackjack/stay' do
  dealer_hand = BJHelper::Dealer.new(session[:dealer_hand]).load_dealer_hand
  player = BJHelper::Player.new(session[:player_hand], session[:player_bankroll])
  player_bankroll = player.bankroll
  player_hand = player.load_player_hand
  player_bet = session[:player_bet]
  session[:dealer_hand] = dealer_hand.to_json
  session[:player_hand] = player_hand.to_json
  session[:player_bankroll] = player_bankroll.to_json
  erb :"blackjack/stay", locals: { player_bet: player_bet, player_bankroll: player_bankroll, dealer_hand: dealer_hand, player_hand: player_hand }
end

post '/stay' do
  dealer_hand = BJHelper::Dealer.new(session[:dealer_hand]).load_dealer_hand
  player = BJHelper::Player.new(session[:player_hand], session[:player_bankroll])
  player_bankroll = player.bankroll
  player_hand = player.load_player_hand
  player_bet = JSON.parse(session[:player_bet],:quirks_mode => true)
  deck = BJHelper::Deck.new
  while deck.checking_points(dealer_hand) < 17
    dealer_hand << deck.deal_hand
  end
  who_won = deck.check_who_won(player_hand, dealer_hand)
  if who_won == -1
    player_bet = 0
    player_bankroll = player_bankroll - player_bet
    session[:player_bankroll] = player_bankroll.to_json
    session[:player_bet] = player_bet.to_json
  elsif  who_won == 0
    player_bankroll = player_bankroll + player_bet
    session[:player_bankroll] = player_bankroll.to_json
    player_bet = 0
    session[:player_bet] = player_bet.to_json
  else
    player_bankroll = player_bankroll + player_bet*2
    session[:player_bankroll] = player_bankroll.to_json
    player_bet = 0
    session[:player_bet] = player_bet.to_json
  end
  session[:who_won] = who_won.to_json
  session[:dealer_hand] = dealer_hand.to_json
  session[:player_hand] = player_hand.to_json
  erb :"blackjack/results", locals: { player_bet: player_bet, player_bankroll: player_bankroll, who_won: who_won, dealer_hand: dealer_hand, player_hand: player_hand }
  redirect to("/blackjack/results")
end

get '/blackjack/results' do
  dealer_hand = BJHelper::Dealer.new(session[:dealer_hand]).load_dealer_hand
  player = BJHelper::Player.new(session[:player_hand], session[:player_bankroll])
  player_bankroll = player.bankroll
  player_hand = player.load_player_hand
  player_bet = JSON.parse(session[:player_bet],:quirks_mode => true)
  who_won = JSON.parse(session[:who_won],:quirks_mode => true)
  erb :"blackjack/results", locals: { player_bet: player_bet, player_bankroll: player_bankroll,who_won: who_won, dealer_hand: dealer_hand, player_hand: player_hand }
end

post '/new_game' do
  session.delete(:dealer_hand)
  session.delete(:player_hand)
  session.delete(:player_bankroll)
  session.delete(:who_won)
  session[:player_bet] = 0
  redirect to("/blackjack/bet")
end

post '/continue_game' do
  session.delete(:dealer_hand)
  session.delete(:player_hand)
  session.delete(:who_won)
  session[:player_bet] = 0
  redirect to("/blackjack/bet")
end

