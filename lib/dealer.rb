require_relative 'player.rb'
require_relative 'deck.rb'

class Dealer < Player
	attr_reader :deck

	def initialize(options={})
		super(options)
		@deck = options[:deck] || Deck.new
	end

	def deal(player)
		2.times do
			player.hand.add(@deck.pop)
			@hand.add(@deck.pop)
		end
	end

	def hit(player)
		player.hand.add(@deck.pop)
	end

	def turn
		until @hand.points >= 17
			hit(self)
		end
	end
end