

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





end #./Module