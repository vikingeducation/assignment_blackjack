class Player

  attr_reader :hand

  def initialize(hand = nil)
    hand ||= []
    @hand = hand
  end

  def draw(cards)
    @hand << cards.pop
  end

  def hit(cards)
    draw(cards)
  end

  def hand_value
    values = @hand.map{ |card| card[0] }
    high_ace = values.inject do |total, value|
      value = 13 ? total + 11 : total + [value, 10].min
    end

    low_ace = values.inject do |total, value|
      value = 13 ? total + 1 : total + [value, 10].min
    end

    if low_ace < 21 && high_ace < 21
      [low_ace, high_ace].max
    elsif low_ace > 21 && high_ace < 21
      high_ace
    elsif low_ace < 21 && high_ace > 21
      low_ace
    end
  end



end