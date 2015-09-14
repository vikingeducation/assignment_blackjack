require 'sinatra'

get '/' do
	erb :'layout.html' do
		erb :'index.html'
	end
end

get '/blackjack' do
	erb :'layout.html' do
		erb :'game.html'
	end
end
