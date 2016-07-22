require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
# also_reload './views'

enable :sessions

get '/' do
  "<h1>Welcome!</h1><br><a href='/blackjack'>Play blackjack!</a>"
end

get '/blackjack' do
  erb :blackjack
end