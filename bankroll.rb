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

	def evaluate_payouts( game, dealer, player )

		dealer_hand = game.evaluate_cards( dealer )
		player_hand = game.evaluate_cards( player )

		if dealer_hand > 21 && player_hand <= 21

			if player_hand == 21 && player.count == 2

				@bankroll += ( ( ( @bet * 3 ) / 2 ) + @bet )

			else

				@bankroll += ( @bet * 2 )

			end

		elsif dealer_hand <= 21 && player_hand <= 21

			if dealer_hand < player_hand

				@bankroll += ( @bet * 2 )

			end

		elsif dealer_hand == player_hand

			@bankroll += @bet

		end

	end


end