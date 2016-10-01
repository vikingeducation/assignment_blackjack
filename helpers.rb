

module Helper

	def save_session

	session[:player] = @player.to_json
	session[:dealer] = @dealer.to_json
  session[:deck] = @deck.to_json
  session[:bj] = @game.to_json

	end






end