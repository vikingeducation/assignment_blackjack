require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

# root route
get '/' do
  erb :home
end

# main game route
get '/blackjack' do
  # main game view
  erb :blackjack
end
