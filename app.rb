# app.rb
require 'sinatra'
require 'erb'
require "sinatra/reloader"
require './lib/blackjack.rb'
require 'pry-byebug'

enable :sessions
helpers BlackjackHelper

get '/' do
 new_game
 erb :home
end

get '/blackjack' do
  # create_deck
  deck = load_deck(session["deck"])
  deal
  # add game_over logic
  erb :blackjack, locals: {p_hand: session[:p_hand], c_hand: session[:c_hand]}
end

post '/blackjack/hit' do
  # adds cards to deck and rerenders page
  hit
  blackjack?
  bust?
  redirect to('/blackjack')
end

post '/blackjack/stay' do
  # deals hand to dealer until conclusion
  stay
  redirect to('/blackjack')
end

post '/blackack/bet' do


end

post '/blackjack/new' do
  new_game
  redirect to('/blackjack')
end
