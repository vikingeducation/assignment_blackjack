require 'pry'
class Blackjack
	attr_accessor :deck, :player_hand, :computer_hand, :player_score, :sum
	SUIT = %w(clubs diamonds spades hearts)
	VALUE = %w(2 3 4 5 6 7 8 9 10 J Q K A)
	#create card struct with suit & value
	Card = Struct.new(:suit, :value)
	#sets up player and computer hands
	def initialize
		build_deck
		@player_hand = []
		@computer_hand = []
		@sum = 0
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


  def get_player_score
  	
  	@player_hand.map do |card|
  		
  		card.value = check_if_face_card_or_ace?(card)
  	
  		@player_score = sum_up_cards(@player_hand)
  	 	end
 		  @player_score
  end

  def get_computer_score
  	@computer_hand.map do |card|
  		card.value = check_if_face_card_or_ace(card)
  	end
  	@computer_score = sum_up_cards(@computer_hand)
  end


  def check_if_face_card_or_ace?(card)
  	if card.value == "J" || card.value == "Q" || card.value == "K"
  		 card.value = 10
  		elsif card.value == "A" && @sum < 21
  			card.value = 11
  	end
  	   card.value
  end

  def sum_up_cards(cards)
  	@sum = 0
  	
  	cards.map do |card|
  		@sum += card.value.to_i
  	end
  	 @sum

  end


 


end


game = Blackjack.new

game.deal_cards
game.get_player_score


