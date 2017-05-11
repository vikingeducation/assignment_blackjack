require 'pry'
class Blackjack
	attr_accessor :deck, :player_hand, :computer_hand, :card, :score, :face_card
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
     	puts @player_hand
  end

  def deal_computer_hand
  	0...2.times do
  		@computer_hand << @deck.pop
  	end
  	  @computer_hand
  end

  #def get_player_score
  	#check_if_face_card?(@player_hand)
  	#check_if_ace?
   # @score = @player_hand[0].value.to_i + @player_hand[1].value.to_i
    #puts @score
  #end

  def get_player_score
  	puts @player_hand
  	@player_hand.map do |card|
  		#card.value = check_if_ace?(card)
  		card.value = check_if_face_card?(card)
  	end
  		@score = sum_up_cards(@player_hand)
  	 
 puts @score
  end

  def check_if_face_card?(card)
  	if card.value == "J" || card.value == "Q" || card.value == "K"
  		 card.value = 10
  	end
  	   card.value
  end

  def sum_up_cards(cards)
  	sum = 0
  	#cards[0].value.to_i + cards[1].value.to_i
  	cards.map do |card|
  		sum += card.value.to_i
  	end
  	 sum

  end


 


end


game = Blackjack.new

game.deal_cards
game.get_player_score


