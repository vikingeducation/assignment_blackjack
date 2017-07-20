module Deck
  class Deck

    def initialize
      face = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
      suit = ["hearts", "spades", "clubs", "diamonds"]
      @deck = face.product(suit)
    end

    def deal_cards(num_of_cards)
      hand = @deck.sample(num_of_cards)
      hand.each do |card_in_hand|
        @deck.delete_if { |card_in_deck| card_in_deck == card_in_hand }
      end
      hand
    end

  end
end
