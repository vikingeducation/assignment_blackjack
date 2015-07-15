
require 'sinatra'
require 'erb'
require './blackjack.rb'
require 'pry'

enable :sessions

helpers do
 include Blackjack

  def check_winner(d_hand,p_hand)
    
    if blackjack?(d_hand) && blackjack?(p_hand)
      redirect '/blackjack/tie', locals: {d_hand: session['d_hand'], p_hand: session['p_hand']}
    elsif blackjack?(d_hand) && !blackjack?(p_hand)
    redirect '/blackjack/gameover', locals: {d_hand: session['d_hand'], p_hand: session['p_hand']}
    elsif blackjack?(p_hand)
      redirect '/blackjack/win', locals: {d_hand: session['d_hand'], p_hand: session['p_hand']}
    end

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
  session['d_hand'] = d_hand
  session['p_hand'] = p_hand
  redirect '/blackjack/gameover', locals: {d_hand: d_hand, p_hand: p_hand} if bust?(p_hand)
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand}
end

post '/blackjack/stay' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  dealer_plays(d_hand + p_hand, d_hand)
  win = false
  win = true if bust?(d_hand)
  win = true if value_hand(p_hand) > value_hand(d_hand)
  erb :stay, locals: {d_hand: d_hand, p_hand: p_hand, win: win}
end

get '/blackjack/gameover' do
  erb :gameover, locals: {d_hand: session['d_hand'], p_hand: session['p_hand']}
end