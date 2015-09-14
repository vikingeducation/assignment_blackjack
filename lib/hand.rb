class Hand
	attr_accessor :cards

	def initialize(options={})
		@cards = options[:cards] || []
	end

	def clear
		@cards = []
	end

	def add(card)
		@cards << card
	end

	def points
		value = 0
		aces = []
		@cards.each do |card|
			card_value = card[1]
			if [1].include?(card_value)
				aces << card_value
				value += 11
			elsif [11, 12, 13].include?(card_value)
				value += 10
			else
				value += card_value
			end
		end
		while value > 21 && aces.length > 0
			value -= 11
			value += 1
			aces.pop
		end
		value
	end
end