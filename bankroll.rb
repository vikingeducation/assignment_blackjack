require 'pry-byebug'

class Bankroll


	attr_accessor :bankroll, :bet


	def initialize( bankroll = 1000, bet = 20 )

		@bankroll = bankroll
		@bet = bet

	end

	def enough_money?

		!!( @bankroll - @bet > 0 )

	end


	


end #./Bankroll