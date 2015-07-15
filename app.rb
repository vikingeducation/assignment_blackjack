
require 'sinatra'
require 'erb'
require './blackjack.rb'
require 'pry'

enable :sessions

helpers do
  include Blackjack

  def check_winner(d_hand,p_hand)

    if blackjack?(d_hand) && blackjack?(p_hand)
      tie
    elsif blackjack?(d_hand) && !blackjack?(p_hand)
      game_over
    elsif blackjack?(p_hand)
      win
    end

  end

  def game_over
    redirect "/blackjack/result/You Lose..."
  end

  def win
    redirect "/blackjack/result/You Win!"
  end

  def tie
    redirect "/blackjack/result/You Pushed!"
  end
end


get '/' do
  'hello world'
end

get '/blackjack' do
  d_hand, p_hand = initial_hands
  session['d_hand'] = d_hand
  session['p_hand'] = p_hand

  check_winner(d_hand,p_hand)
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand}
end

post '/blackjack/hit' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  deal(d_hand + p_hand, p_hand)
  session['d_hand'], session['p_hand'] = d_hand, p_hand

  game_over if bust?(p_hand)
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand}
end

post '/blackjack/stay' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  dealer_plays(d_hand + p_hand, d_hand)
  win if bust?(d_hand)
  win if value_hand(p_hand) > value_hand(d_hand)
  tie if value_hand(p_hand) == value_hand(d_hand)
  game_over
end

get '/blackjack/result/:message' do
  erb :result, locals: {p_hand: session['p_hand'], d_hand: session['d_hand'], message: params[:message]}
end