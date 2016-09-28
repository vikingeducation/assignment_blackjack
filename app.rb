require "sinatra"
require "sinatra/reloader" if development?

enable :sessions

get '/blackjack' do
  erb :"blackjack.html"
end