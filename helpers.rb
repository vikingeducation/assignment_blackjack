

module Helper

	def save_session

	session[:player] = @player.to_json
	session[:dealer] = @dealer.to_json
  session[:deck] = @deck.to_json
  session[:bj] = @game.to_json

	end



	def parse_session

		@player = JSON.parse( session[ :player ] )
		@dealer = JSON.parse( session[ :dealer ] )
		@game = Deck.new( JSON.parse( session[ :deck ] ) )

	end




end