require 'sinatra'

get '/' do
  redirect to 'blackjack'
end

get '/blackjack' do
  erb :navigation
end