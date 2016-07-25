require 'sinatra'
require 'erb'
require './helpers/bj_help.rb'

enable :sessions

helpers BJ

get '/' do

  erb :home
end

get '/blackjack' do
  new_deck
  @phand = new_hand("player")
  @dhand = new_hand("dealer")
  @deck = session["deck"]
  erb :blackjack
end

post '/blackjack/hit' do
  hit
  sum = hand_sum("player")
  @phand = session["playerhand"]
  @dhand = session["dealerhand"]
  @deck = session["deck"]
  sum > 21 ? redirect '/blackjack/stay' : erb :blackjack

end

get '/blackjack/stay' do

end
