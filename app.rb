# ./app.rb
require "sinatra"
require "sinatra/reloader" if development?
require 'erb'
require 'pry-byebug'

enable :sessions


get '/' do
  erb :home
end

get '/blackjack' do
  # Game starts here
  erb :blackjack
end