require 'sinatra'
require 'erb'

require 'pry-byebug'

#enable :sessions

get '/' do

	erb :home

end

post '/blackjack' do

	erb :blackjack

end