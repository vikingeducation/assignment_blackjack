require 'sinatra'
enable :sessions

get '/' do
	"hello world"
		erb :home
end

get '/blackjack' do
	erb :"blackjack"
end