require 'sinatra'
require 'erb'
require './deck.rb'
require 'json'

require 'pry-byebug'



#enable :sessions

get '/' do

	erb :home

end

post '/blackjack' do
binding.pry
# when the page is loaded the cards should be dealt to the player and dealer
# a deck class could be implemented to handle the shuffling of the cards
  @deck = Deck.new( JSON.parse( session[:deck] ) ) # cant parse nil
# the cards are then distributed to the player and dealer when the page loads
	# the deck has 52 cards (A-K)
	# the cards could be an array that is shuffled
	# using product method, those cards could be distributed in that manner

	#erb :blackjack, locals: { dealer: move, player: move }

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

