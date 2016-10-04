require 'pry-byebug'

class Bankroll


	attr_accessor :bankroll, :bet


	def initialize( bankroll = 1000, bet = 0 )

		@bankroll = bankroll.to_i
		@bet = bet.to_i

	end

	def valid_bet?

		!!( @bankroll - @bet > 0 )

	end





end #./Bankroll