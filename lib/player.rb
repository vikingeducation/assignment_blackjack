class Player
	attr_accessor :hand, :bank, :staying

	def initialize(options={})
		@hand = options[:hand] || Hand.new
		@bank = options[:bank] || 1000
		@staying = false
	end

	def reset
		@hand.clear
		@staying = false
	end

	def bet(amount)
		if @bank >= amount && amount > 0
			bet = amount
			@bank -= amount
		end
		bet
	end

	def stay
		@staying = true
	end

	def betting?
		@hand.cards.empty?
	end

	def staying?
		@staying
	end

	def ties?(player)
		player.hand.points == @hand.points
	end

	def beats?(player)
		player.hand.points < @hand.points
	end

	def blackjack?
		@hand.points == 21
	end

	def bust?
		@hand.points > 21
	end
end