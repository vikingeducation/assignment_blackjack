class Human
  attr_reader :hand
  def initialize
    @hand = []
  end

  def hand_sum
    @hand.collect { |card| card[0] }.inject(&:+)
  end

  def bust?
    hand_sum > 21
  end

  def has_blackjack?
    @hand[0..1].collect { |card| card[0] }.inject(&:+)
  end

end