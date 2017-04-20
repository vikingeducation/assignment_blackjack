require 'sinatra'
require 'shotgun'

get '/' do
  erb :index
end

post '/blackjack' do
  erb :blackjack
end
