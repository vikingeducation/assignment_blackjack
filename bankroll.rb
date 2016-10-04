require 'pry-byebug'

class Bankroll


	attr_accessor :bankroll, :bet


	def initialize( bankroll = 1000, bet = 0 )

		@bankroll = bankroll.to_i
		@bet = bet.to_i

	end

	def valid_bet?

		if ( @bankroll - @bet > 0 )

			@bankroll -= @bet

			true

		else

			false

		end

	end





end #./Bankroll