class Player

  attr_reader :hand

  def initialize(hand=Hand.new.hand_arr)

    @hand = hand.empty? ? hand : Hand.new(hand_arr)

  end

  def hit(card)
    @hand << card
  end

  def stay
    @hand
  end


end