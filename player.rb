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

  def hand_value(hand)
    aces = 0
    remaining = aces - 1
    values = hand.map{ |card| card[0] }
    sum = 0
    values.each do |value|
      value == 13 ? aces += 1 : sum += [value, 10].min
    end

    if aces > 0
      return sum + 11 + remaining if sum + 11 + remaining <= 21
      return sum + aces if sum + 11 + remaining > 21 
    end

    sum
  end

  
  def bust?(hand)
    return true if hand_value(hand) > 21
    false
  end

  def blackjack?(hand)
    return true if hand_value(hand) == 21
    false
  end

end