module Deck

class DealHands

  CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 1]

  attr_reader :player_hand, :dealer_hand, :game_deck

  def initialize(player_hand = [], dealer_hand = [], game_deck = [])
    @player_hand = player_hand
    @dealer_hand = dealer_hand
    @game_deck = game_deck
    if @player_hand.empty? && @dealer_hand.empty?
      build_deck
      first_deal
    end
  end

  def build_deck
    @game_deck = CARDS * 4
    @game_deck.shuffle!
  end

  def deal_to_player
    @player_hand << @game_deck.pop
  end

  def first_deal
    2.times do
      deal_to_dealer
      deal_to_player
    end
  end

  def deal_to_dealer
    @dealer_hand << @game_deck.pop
  end

  def count_hand_value(hand)
    hand.inject(0) {|sum, card_val| sum + card_val}
  end

  def check_who_won
    player_score = count_hand_value(@player_hand)
    dealer_score = count_hand_value(@dealer_hand)
    if player_score > 21
      "You Busted"
    elsif dealer_score > 21
      "Dealer Busted. You Win!"
    elsif player_score == dealer_score
      "Draw"
    elsif player_score > dealer_score
      "You won"
    else
      "Dealer won"
    end
  end
end

end