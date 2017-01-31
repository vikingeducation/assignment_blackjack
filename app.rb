require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

get '/blackjack' do
  erb :blackjack
end
