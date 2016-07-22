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
    aces = 0
    values = @hand.map{ |card| card[0] }
    sum = values.inject do |total, value|
      value = 13 ? aces += 1 : total + [value, 10].min
    end
    # add ages and values logically
  end



end