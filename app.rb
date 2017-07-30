# app.rb
require 'sinatra'
require 'erb'
require "sinatra/reloader"
require './lib/blackjack.rb'

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

  erb :blackjack, locals: {p_hand: session[:p_hand], c_score: score(session[:c_hand]), p_score: score(session[:p_hand]), deck: deck}
end

post '/blackjack/hit' do
  # adds cards to deck and rerenders page
  hit
  redirect to('/blackjack')
end

post '/blackjack/stay' do
  # deals hand to dealer until conclusion
  stay
  redirect to('/blackjack')
end

post '/blackjack/new' do
  new_game
  redirect to('/blackjack')
end
