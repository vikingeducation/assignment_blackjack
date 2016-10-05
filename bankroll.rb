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
binding.pry
		dealer_hand = game.evaluate_cards( dealer )
		player_hand = game.evaluate_cards( player )
binding.pry
		if dealer_hand <= 21

			if dealer_hand > player_hand

			end

		end

		if player_hand <= 21

			if player_hand > dealer_hand



			end

		end

		if player_hand == 21 && player.count == 2

			# blackjack and player gets paid 3:2
			# goes to player bankroll

		elsif dealer_hand > player_hand

			# dealer wins and bet is removed
			# new game is prompted
			# new bets are made

		elsif dealer_hand == player_hand

			# tie and bet goes back into player's bankroll
			# new game is prompted
			# new bets are made

		elsif dealer_hand < player_hand

			# player wins and players bet is multiplied by 2 and added to player bankroll
			# new game is prompted
			# new bets are made

		 end

	end



end #./Bankroll