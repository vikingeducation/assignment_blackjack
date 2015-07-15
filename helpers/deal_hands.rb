module Deck

class DealHands

  CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 1]

  attr_reader :player_hand, :dealer_hand, :deck

  def initialize(player_hand = [], dealer_hand = [])

    @player_hand = player_hand
    @dealer_hand = dealer_hand
    build_deck
    first_deal if @player_hand.empty? && @dealer_hand.empty?
  end

  def build_deck

    @deck = CARDS * 4
    @deck.shuffle!

  end

  def deal_to_player

    @player_hand << @deck.pop

  end

  def first_deal

    2.times do
      deal_to_dealer
      deal_to_player
    end

  end

  def deal_to_dealer

    @dealer_hand << @deck.pop

  end

  def count_hand_value(hand)
    hand.inject(0) {|sum, card_val| sum + card_val}
  end

end

end