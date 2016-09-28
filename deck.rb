require 'pry-byebug'

class Deck

	def initialize( deck )
binding.pry
		deck ? @deck = deck : @deck = [ "A", "A", "A", "A",
							"2", "2", "2", "2",
							"3", "3", "3", "3",
							"4", "4", "4", "4",
							"5", "5", "5", "5",
							"6", "6", "6", "6",
							"7", "7", "7", "7",
							"8", "8", "8", "8",
							"9", "9", "9", "9",
							"10","10","10","10",
							"J", "J", "J", "J",
							"Q", "Q", "Q", "Q",
							"K", "K", "K", "K" ]
binding.pry
	end


	def shuffle

		@deck.shuffle!

	end


	def deal

		@deck.pop(2)

	end



	def draw



	end


end