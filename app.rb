require 'sinatra'
require 'pry-byebug'
require 'erb'

get '/' do
  redirect to('blackjack')
end

get '/blackjack' do
  erb :"blackjack"
end