

module Helper

	def save_session

		session[ :player ] = @player.to_json
		session[ :dealer ] = @dealer.to_json
	  session[ :deck   ] = @deck.to_json
	  session[ :total  ] = @total.to_json

	end

	def bust?( total )

		!!( total > 21 )

	end


	def parse_session

		if !session[ :deck ].nil?
			@game = Deck.new( JSON.parse( session[ :deck   ] ),
												JSON.parse( session[ :player ] ),
												JSON.parse( session[ :dealer ] ),
												JSON.parse( session[ :total  ] )
											)
		else
			@game = Deck.new
		end

	end


	def assign_variables

		@player = @game.player_cards
		@dealer = @game.dealer_cards
		@deck   = @game.deck
		@total  = @game.total

	end


	def start_dealer_turn( dealer )

		@game.evaluate_cards( dealer )

	end

	def dealer_ai( dealer_total )

		return if dealer_total >= 17

			@dealer += @game.hit
			dealer_total = start_dealer_turn( @dealer )
			dealer_ai( dealer_total )

	end


end #./Module