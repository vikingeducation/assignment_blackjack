
require 'sinatra'
require 'sinatra/flash'
require 'erb'
require './helpers.rb'

enable :sessions

helpers BlackjackHelpers

get '/' do
  'hello world'
end

# in game - are we in a game?
# money - player's money
# bet - current bet value
# d_hand - dealer
# p_hand - player hand
# split_hands - array of hands

# Give the player money if they've just opened the page.
get '/bet' do
  redirect '/blackjack' if session['ingame']
  if session['money'] && session['money'] == 0
    flash.now[:danger] = "You've run out of money. Try to be more carful!"
  end
  session['money'] = 1000 unless (session['money'] && session['money'] > 0)
  erb :bet, locals: {money: session['money']}
end


# Redirect to blackjack if a game is in progress.
# If the player tries to bet more money than they have,
# Redirect them to the betting page with an error.
post '/bet' do
  redirect '/blackjack' if session['ingame']
  if session['money'] && session['money'] >= params[:amt].to_i
    session['bet'] = (params[:amt].to_i).abs
    session['money'] -= session['bet']
    redirect '/blackjack'
  else
    flash[:notice] = "Insufficient Funds."
    redirect '/bet'
  end
end

# If they're in a game, load the dealer and player hands.
# Else, generate the hands, and say that they player
# is now in a game.
get '/blackjack' do
  if session['ingame']
    d_hand = session['d_hand']
    p_hand = session['p_hand']
  elsif session['bet'].nil?
    flash[:notice] = "You must make a bet before you get cards!"
    redirect '/bet'
  else
    d_hand, p_hand = initial_hands
    session['d_hand'] = d_hand
    session['p_hand'] = p_hand
    session['ingame'] = true
  end

  check_winner(d_hand,p_hand)
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand, split: session["split_hands"], money: session['money'], bet: session['bet']}
end

# When the player hits, deal them a card.
# Update the player and dealer hands.
# Redirect the player to the results screen if they've busted.
post '/blackjack/hit' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  deal(d_hand + p_hand, p_hand)
  session['d_hand'], session['p_hand'] = d_hand, p_hand

  game_over if bust?(p_hand)
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand, split: session["split_hands"], money: session['money'], bet: session['bet']}
end

# When the player decides to stay, have the dealer hit until 17.
# Then, the player wins if the dealer busts or has a lower hand value.
# The player and dealer tie if they have equal hand values.
# Otherwise, the player loses.
post '/blackjack/stay' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  dealer_plays(d_hand + p_hand, d_hand)
  calculate_result(d_hand, p_hand)
end

# The player shouldn't be able to double unless it's their first turn
# If they try, we punish them by making them stay.
post '/blackjack/double' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  if p_hand.length == 2 && session['money'] >= session['bet']
    deal(d_hand + p_hand, p_hand)
    session['money'] -= session['bet']
    session['doubled'] = true
  else
    flash[:notice] = "Nice try, you shouldn't actually be able to double here."
  end
  dealer_plays(d_hand + p_hand, d_hand)
  calculate_result(d_hand, p_hand)
end

post '/blackjack/split' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  if session['money'] >= session['bet']
    session['money'] -= session['bet']
    split_hand = [p_hand[1]]
    deal(d_hand + [p_hand[0]] + split_hand, split_hand)
    if session['split_hands']
      session['split_hands'] << split_hand
    else
      session['split_hands'] = [split_hand]
    end
    p_hand = [p_hand[0]]
    session['p_hand'] = p_hand
    deal(d_hand + p_hand, p_hand)
  else
    flash[:notice] = "You don't have the money to split!"
  end
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand, split: session["split_hands"], money: session['money'], bet: session['bet']}
end


# Generic results screen that can display win/lose/push message.
get '/blackjack/result/' do
  erb :result, locals: {p_hand: session['p_hand'], d_hand: session['d_hand'], money: session['money']}
end