require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
# also_reload './views'

helpers BlackjackHelper
enable :sessions

get '/' do
  "<h1>Welcome!</h1><br><a href='/blackjack'>Play blackjack!</a>"
end

get '/blackjack' do
  erb :blackjack
end

post '/blackjack/hit' do
  # add_card
  redirect ('blackjack')
end

post '/blackjack/stay' do

  redirect ('blackjack')
end
