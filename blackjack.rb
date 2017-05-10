class Blackjack
	attr_accessor :deck, :player_hand, :computer_hand, :card
	SUIT = %w(clubs diamonds spades hearts)
	VALUE = %w(2 3 4 5 6 7 8 9 10 J Q K A)
	Card = Struct.new(:suit, :value)

	def initialize
		build_deck
		@player_hand = player_hand
		@computer_hand = computer_hand
  end
  #iterates through suit and value and creates card struct
  #and puts them into array
  def build_deck
  	@deck = []
  	SUIT.each do |type|
  		VALUE.each do |val|
        @card  = Card.new(type, val)
        @deck << @card
  		end
  	end
  	@deck
  end

  def deal_cards
  	 @deck[0].value
  end
end



