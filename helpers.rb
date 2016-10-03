

module Helper

	def parse_and_assign_variables

		parse_session
		assign_variables

	end


	def save_session

		session[ :player ] = @player.to_json
		session[ :dealer ] = @dealer.to_json
	  session[ :deck   ] = @deck.to_json

	end

	def bust?( total )

		!!( total > 21 )

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


	def start_dealer_turn
		# pass total of dealer cards to dealer AI
		dealer_ai( @game.evaluate_cards( @dealer ) )

	end

	def dealer_ai( dealer_total )
		# dealer will hit until 17
		return if dealer_total >= 17

			@dealer += @game.hit
			start_dealer_turn

	end


end #./Module