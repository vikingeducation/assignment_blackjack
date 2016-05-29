require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'
require 'pry-byebug'


get '/' do
  erb :index
end

get '/blackjack' do
  "<h1>this is blackjac!</h1>"
end
