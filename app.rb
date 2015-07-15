
require 'sinatra'
require 'erb'


get '/' do
  'hello world'
end

get '/blackjack' do
  erb :blackjack
end