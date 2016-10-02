require 'pry-byebug'

	# the deck has 52 cards (A-K)
	# the cards could be an array that is shuffled
class Deck

	attr_reader :deck, :player_cards, :dealer_cards

	def initialize( deck = nil, player_cards = [], dealer_cards = [] )

		@player_cards = player_cards
		@dealer_cards = dealer_cards

		if deck

			@deck = deck

		else

			@deck = [ "A", "A", "A", "A",
							"2", "2", "2", "2",
							"3", "3", "3", "3",
							"4", "4", "4", "4",
							"5", "5", "5", "5",
							"6", "6", "6", "6",
							"7", "7", "7", "7",
							"8", "8", "8", "8",
							"9", "9", "9", "9",
							"10","10","10","10",
							"J", "J", "J", "J",
							"Q", "Q", "Q", "Q",
							"K", "K", "K", "K" ]

			shuffle
			deal

		end


# add shuffle internally
	end





	def shuffle

		@deck.shuffle!

	end


	def deal

		@player_cards << @deck.pop( 2 )
		@dealer_cards << @deck.pop( 1 )

	end



	def hit

		@deck.pop( 1 )

	end



end