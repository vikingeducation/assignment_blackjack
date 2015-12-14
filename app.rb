require 'sinatra'
require 'erb'
require 'pry'

# saves deck and hands
enable :sessions

get '/' do
  erb :index
end

get '/blackjack' do
  erb :blackjack
end