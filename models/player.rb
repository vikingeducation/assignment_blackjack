class Player

  attr_accessor :hand, :hand_value, :bankroll

  def initialize(hand:, hand_value:, bankroll:)
    @name = "You"
    @hand = hand
    @hand_value = hand_value
    @bankroll = bankroll
  end

  def calculate_hand
    @hand.reduce(0) do |memo, card|
      value = if card[0].class == Integer
        card[0]
      elsif %w(J Q K).include?(card[0])
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

end

class Dealer < Player

  def initialize(hand:, hand_value:)
    @name = "Dealer"
    @hand = hand
    @hand_value = hand_value
  end

end