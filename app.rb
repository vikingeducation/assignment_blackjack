require 'sinatra'
require 'erb'
require 'pry-byebug'
require 'sinatra/reloader' if development?


get '/' do
  erb :home
end

get '/blackjack' do
  # needs to shuffle deck and deal hands to dealer and player
  erb :blackjack # renders these things
end

post '/blackjack/hit' do
  # adds a card to the players hand and re-renders the main page
  # if hitting would bust player (over 21 total) redirect to get /blackjack/stay
  # need to use cookies to keep track of cards already dealt?
end

post '/blackjack/stay' do
  # gets dealer to play their hand - either hit or stay depending on if product is 17 or higher
  # render main page with all cards revealed and describes the result
end
