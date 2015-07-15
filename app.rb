
require 'sinatra'
require 'erb'
require './blackjack.rb'
require 'pry'

enable :sessions

helpers do
  include Blackjack

  # When the initial cards are dealt, check for blackjacks.
  def check_winner(d_hand,p_hand)

    if blackjack?(d_hand) && blackjack?(p_hand)
      tie
    elsif blackjack?(d_hand) && !blackjack?(p_hand)
      game_over
    elsif blackjack?(p_hand)
      blackjack
    end

  end

  # game_over/win/lose/blackjack all set the 'ingame' flag to false to
  # denote that the player is finished with their current game.

  def game_over
    session['ingame'] = false
    redirect "/blackjack/result/You Lose..."
  end

  def win
    session['ingame'] = false
    session['money'] += session['bet'] * 2
    redirect "/blackjack/result/You Win!"
  end

  def blackjack
    session['ingame'] = false
    session['money'] += session['bet'] * 2.5
    redirect "/blackjack/result/Blackjack!"
  end

  def tie
    session['ingame'] = false
    session['money'] += session['bet']
    redirect "/blackjack/result/You Pushed!"
  end
end


get '/' do
  'hello world'
end

# Give the player money if they've just opened the page.
get '/bet' do
  session['money'] = 1000 unless session['money']
  erb :bet, locals: {msg: nil, money: session['money']}
end

get '/bet/error' do
  session['money'] = 1000 unless session['money']
  erb :bet, locals: {msg: "Not enough money.", money: session['money']}
end

# Redirect to blackjack if a game is in progress.
# If the player tries to bet more money than they have,
# Redirect them to the betting page with an error.
post '/bet' do
  redirect '/blackjack' if session['ingame']
  if session['money'] && session['money'] >= params[:amt].to_i
    session['bet'] = params[:amt].to_i
    session['money'] -= params[:amt].to_i
    redirect '/blackjack'
  else
    redirect '/bet/error'
  end
end

# If they're in a game, load the dealer and player hands.
# Else, generate the hands, and say that they player
# is now in a game.
get '/blackjack' do
  if session['ingame']
    d_hand = session['d_hand']
    p_hand = session['p_hand']
  else
    d_hand, p_hand = initial_hands
    session['d_hand'] = d_hand
    session['p_hand'] = p_hand
    session['ingame'] = true
  end

  check_winner(d_hand,p_hand)
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand}
end

# When the player hits, deal them a card.
# Update the player and dealer hands.
# Redirect the player to the results screen if they've busted.
post '/blackjack/hit' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  deal(d_hand + p_hand, p_hand)
  session['d_hand'], session['p_hand'] = d_hand, p_hand

  game_over if bust?(p_hand)
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand}
end

# When the player decides to stay, have the dealer hit until 17.
# Then, the player wins if the dealer busts or has a lower hand value.
# The player and dealer tie if they have equal hand values.
# Otherwise, the player loses.
post '/blackjack/stay' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  dealer_plays(d_hand + p_hand, d_hand)
  win if bust?(d_hand)
  win if value_hand(p_hand) > value_hand(d_hand)
  tie if value_hand(p_hand) == value_hand(d_hand)
  game_over
end

# Generic results screen that can display win/lose/push message.
get '/blackjack/result/:message' do
  erb :result, locals: {p_hand: session['p_hand'], d_hand: session['d_hand'], message: params[:message], money: session['money']}
end