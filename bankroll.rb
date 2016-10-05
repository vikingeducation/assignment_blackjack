require 'pry-byebug'

class Bankroll


	attr_accessor :bankroll, :bet


	def initialize( bankroll = 1000, bet = 0 )

		@bankroll = bankroll.to_i
		@bet = bet.to_i

	end

	def valid_bet?

		if ( @bankroll - @bet >= 0 )

			@bankroll -= @bet

			true

		else

			false

		end

	end

	def evaluate_hands( game, dealer, player )

		dealer_hand = game.evaluate_cards( dealer )
		player_hand = game.evaluate_cards( player )

		# @bankroll or bankroll
		# @bet or bet

		# tie for blackjack
		if dealer_hand == 21 && player_hand == 21

			@bankroll += @bet

		# if player has 21 and two cards its a blackjack paid 3:2
		elsif player_hand == 21 && player.count == 2

			@bankroll += ( ( ( @bet * 3 ) / 2 ) + @bet )

		elsif dealer_hand < 21 && player_hand < 21

			# eval for player winning without blackjack
			if dealer_hand < player_hand

				@bankroll += ( @bet * 2 )

			end

		end


binding.pry

	end



end #./Bankroll