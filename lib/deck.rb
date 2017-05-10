class Deck
	attr_accessor :cards

	def initialize(options={})
		@cards = options[:cards] || build_deck
	end

	def pop
		build_deck if @cards.empty?
		@cards.pop
	end

	def shuffle
		@cards.shuffle!
	end

	private
		def build_deck
			@cards = []
			suits = ['c', 'd', 'h', 's']
			values = (1..13).to_a
			suits.each do |suit|
				values.each do |value|
					@cards << [suit, value]
				end
			end
			shuffle
		end
end