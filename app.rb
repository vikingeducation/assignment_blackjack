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
	sessions[:player_hand] = game.get_player_score
	erb :"blackjack", :locals => {:cards => cards}
	
end

post '/blackjack' do 
		if params[:hit])
				game.add_card
		end
	redirect to("blackjack")

end