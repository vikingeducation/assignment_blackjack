# app.rb
require 'sinatra'
require 'erb'
require "sinatra/reloader"
require './lib/blackjack.rb'

enable :sessions
helpers BlackjackHelper

# session["bank"] = 50
# session["p_hand"] = "4"

get '/' do
 erb :home
end

get '/blackjack' do
  # create_deck
  deck = load_deck(session["deck"])
  unless session["p_hand"]
    session["p_hand"] = Array.new
    session["c_hand"] = Array.new
    2.times {hit}
  end
  erb :blackjack, locals: {c_hand: session[:c_hand], p_hand: session[:p_hand], deck: deck}
end

post '/blackjack/hit' do
  # adds cards to deck and rerenders page
  hit
  redirect to('/blackjack')
end

get '/cheese' do
  erb :cheese
end
