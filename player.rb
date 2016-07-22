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
    remaining = aces - 1
    values = hand.map{ |card| card[0] }
    sum = 0
    values.each do |value|
      value == 13 ? aces += 1 : sum += [value, 10].min
    end

    if sum > 21
      return sum + aces
    elsif aces > 0
      return sum + 11 + remaining if sum + 11 + remaining <= 21
      return sum + aces if sum + 11 + remaining > 21 
    else 
      
    end

    # add ages and values logically
  end

  def bust?


  end



end