require 'sinatra'
require 'thin'
require 'byebug'
# require 'sinatra/reloader' if development?

enable :sessions

get '/' do
  erb :index
  # redirect to('/blackjack')
end

get '/blackjack' do
  
end