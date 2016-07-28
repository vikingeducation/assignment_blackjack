require 'sinatra'
require 'erb'
require 'pry-byebug'

enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  erb :blackjack
end
