require 'sinatra'
#require 'sinatra/reloader' if development?
require './helpers/blackjack_helper.rb'
require './blackjack.rb'

helpers BlackjackHelper
enable :sessions

get '/' do
	"hello world"
		erb :home
end

get '/blackjack' do
	game = Blackjack.new
	cards = game.deal_cards
	erb :"blackjack", :locals => {:cards => cards}
	
end

post '/blackjack' do 
	@choice = save_choice(params[:choice])

	redirect to("blackjack")

end