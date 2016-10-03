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


	def evaluate_cards( hand )

		# hand should be sorted to get an ace to the front
		# puts the Ace at the end for final eval if there
		int_hand = hand.map { | card | to_int( card ) }.sort.reverse

		hand_total = add_cards( int_hand )

	end


	def add_cards( hand )
binding.pry
		hand.inject( 0 ) do | r, e |

			if e == 1

				if ( r + 11 ) > 21

					r += e

				else

					r += 11

				end

			else

				r += e

			end

		end



	end


	def to_int( card )

		if ( "10,J,Q,K" ).include?( card )

			card = 10

		elsif ( "2,3,4,5,6,7,8,9" ).include?( card )

			card.to_i

		elsif card == "A"

			card = 1

		end


	end


	def shuffle

		@deck.shuffle!

	end


	def deal

		@player_cards += @deck.pop( 2 )
		@dealer_cards += @deck.pop( 2 )

	end



	def hit

		@deck.pop( 1 )

	end



end