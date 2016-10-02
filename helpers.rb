

module Helper

	def save_session

		session[ :player ] = @player.to_json
		session[ :dealer ] = @dealer.to_json
	  session[ :deck   ] = @deck.to_json

	end



	def parse_session

		if !session[ :deck ].nil?
			@game = Deck.new( JSON.parse( session[ :deck   ] ),
												JSON.parse( session[ :player ] ),
												JSON.parse( session[ :dealer ] )
											)
		else
			@game = Deck.new
		end

	end


	def assign_variables

		@player = @game.player_cards
		@dealer = @game.dealer_cards
		@deck   = @game.deck

	end


	def evaluate_cards

		# taking the array of each card
		@player_cards.each do | card |

			if card.to_i == 0

				binding.pry

			end
		# check the value of each card
		# assign the number value
		# if the value is below 21
		# allow hit or stay
		# else show 'player has blackjack if 21
		# else show BUST if over 21

		end

	end


end #./Module