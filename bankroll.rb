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


		# first we check if the dealer busts && player <= 21
		if dealer_hand > 21 && player_hand <= 21
			# if the player has 21 and two cards
			if player_hand == 21 && player.count == 2
				# then paid 3:2
				@bankroll += ( ( ( @bet * 3 ) / 2 ) + @bet )
			# else
			else
				# paid 1:1
				@bankroll += ( @bet * 2 )
			# end
			end
		# elsif the dealer doesnt bust and the player doesn't bust
		elsif dealer_hand <= 21 && player_hand <= 21
			# if the dealer is less than the player
			if dealer_hand < player_hand
				# player gets 1:1
				@bankroll += ( @bet * 2 )
			# end
			end
		# elsif the dealer == player
		elsif dealer_hand == player_hand
			# push
			@bankroll += @bet
		end
		# end


	end



end #./Bankroll