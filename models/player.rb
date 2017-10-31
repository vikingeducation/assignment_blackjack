require_relative 'deck'

class Player

  attr_accessor :hand, :hand_value, :bankroll

  def initialize
    @name = "You"
    @hand = []
    @hand_value = 0
    @bankroll = 100
  end

  def calculate_hand
    @hand.reduce(0) do |memo, card|
      value = if card[0].class == Integer
        card[0]
      elsif Deck::FACE_CARDS.include?(card[0])
        10
      else
        1
      end
      memo + value
    end #hand
  end

  def set_hand_value
    @hand_value = calculate_hand
  end

  def hit(card)
    @hand << card
    calculate_hand
  end

  def subtract_loss(bet)
    @bankroll -= bet
  end

  def add_winnings(bet)
    @bankroll += bet
  end

end

class Dealer < Player

  def initialize
    @name = "Dealer"
    @hand = []
    @hand_value = 0
  end

end