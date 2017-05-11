class Blackjack
	attr_accessor :deck, :player_hand, :computer_hand, :card
	SUIT = %w(clubs diamonds spades hearts)
	VALUE = %w(2 3 4 5 6 7 8 9 10 J Q K A)
	Card = Struct.new(:suit, :value)

	def initialize
		build_deck
		@player_hand = []
		@computer_hand = []
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
  		deal_player_hand
  		deal_computer_hand
  end

  def deal_player_hand
	  0...2.times do
  	  @deck.shuffle!
  		@player_hand << @deck.pop
    end
      @player_hand
  end

  def deal_computer_hand
  	0...2.times do
  		@computer_hand << @deck.pop
  	end
  	  @computer_hand
  end

end


game = Blackjack.new

game.deal_cards


