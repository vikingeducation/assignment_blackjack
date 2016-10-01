require 'sinatra'
require './deck.rb'
require 'json'
require 'pry-byebug'
require 'helpers'


enable :sessions

include Helpers

get '/' do
	session.clear
	erb :home

end

get 'blackjack' do

	"hello world"

end

post '/blackjack' do

	if !session[:bj].nil?
  	@game = Deck.new( JSON.parse( session[:bj] ) )
  	@deck = @game.deck
  else
  	@game = Deck.new
  	@game.deal
  	@deck = @game.deck
  end



  # if it's a new game then we'll be dealing 2 cards
	@player = @game.player_cards
	@dealer = @game.dealer_cards

	session[:player] = @player.to_json
	session[:dealer] = @dealer.to_json
  session[:deck] = @deck.to_json
  session[:bj] = @game.to_json


	erb :blackjack

end


post '/hit' do

	#grab the deck
	@game = Deck.new( JSON.parse( session[ :deck ] ) )

	@deck = @game.deck

	@player = JSON.parse( session[ :player ] )
	@dealer = JSON.parse( session[ :player ] )
	#grab the player's hand
	#grab the dealer's hand
	@player << @game.hit
	# save the deck
	session[ :deck ] = @deck.to_json
	# save the dealer's hand
	session[ :player ] = @player.to_json
	session[ :dealer ] = @dealer.to_json
	session[ :bj ] = @game.to_json
	# save the player's hand

	#display the blackjack page
	redirect('/blackjack')


end

# cookies / sessions
# the player cards and dealer cards will need to be persisted with each load of the blackjack page
# each 'hit' or 'stay' sends new request
# the players and dealers cards are saved
# the cards in deck must be saved as well
# LATER ITEMS
	# the bet amount
	# player bankroll

# CLASSES for refactoring
	# Deck
	# Computer AI
	# Player - bankroll

# blackjack page handles the functionality for the game

# the dealer's and player's cards are evaluated for blackjack - bets paid 3:2 if player win
	# else the player forfeits bet
# when the player hits
	# another card is dealth to the player and evaluated
		# Until the player busts or stays
			# the players turn ends
		# else
			# the player can hit or stay
		# end
# the dealer's turn begins when the player finishes
	# if the dealer cards < 17
		# dealer hits
	# else
		# dealer stays if < 21
	# end
# dealer turn ends and player dealer cards are evaluated
	# if the dealer < player
		# bet pays 1:1
	# else
		# player loses bet
	# end

