

module Helper

	def save_session

		session[:player] = @player.to_json
		session[:dealer] = @dealer.to_json
	  session[:deck] = @deck.to_json
	  session[:bj] = @game.to_json

	end



	def parse_session

		if session[ :player ].nil?

			@player = @game.player_cards

		else

			@player = JSON.parse( session[ :player ] )

		end

		if session[ :dealer ].nil?

			@dealer = @game.dealer_cards

		else

			@dealer = JSON.parse( session[ :dealer ] )

		end

		if session[ :deck ].nil?

			@game = Deck.new

		else

		  @game = Deck.new( JSON.parse( session[ :deck ] ) )

		end


	end




end