
require 'sinatra'
require 'erb'
require './blackjack.rb'
require 'pry'

enable :sessions

helpers do
 include Blackjack
end


get '/' do
  'hello world'
end

get '/blackjack' do
  d_hand, p_hand = initial_hands
  session['d_hand'] = d_hand
  session['p_hand'] = p_hand
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand}
end

post '/blackjack/hit' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  deal(d_hand + p_hand, p_hand)
  session['d_hand'] = d_hand
  session['p_hand'] = p_hand
  redirect '/blackjack/gameover', locals: {d_hand: d_hand, p_hand: p_hand} if bust(p_hand)
  erb :blackjack, locals: {d_hand: d_hand, p_hand: p_hand}
end

post '/blackjack/stay' do
  d_hand, p_hand = session['d_hand'], session['p_hand']
  erb :stay, locals: {d_hand: d_hand, p_hand: p_hand}
  
end