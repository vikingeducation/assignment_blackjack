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


	def get_hand_value( hand )

		# hand should be sorted to get an ace to the front
		hand.map! { | card | to_int( card ) }

		# puts the Ace at the end for final eval if there
		hand.sort!.reverse!

		hand_total = add_cards( hand )

		bust?( hand_total )

			# then reversed so the Ace is evaluated last
		# then each card is checked
			# if the card is a number it is convered to that number
			# if it is a face card, it is converted to a 10
			# the last card should be an Ace
				# if 11 + current total is > 21
					# the Ace value is one
				# else
					# the Ace value is 11

	end


	def bust?( total )

		total > 21

	end


	def add_cards( hand )

		hand.inject do | r, e |

			if e == 1

				if ( r += 11 ) > 21

					r += e

				end

			else

				r += e

			end

		end



	end


	def evaluate_cards

		get_hand_value( @player_cards )

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
		@dealer_cards += @deck.pop( 1 )

	end



	def hit

		@deck.pop( 1 )

	end



end