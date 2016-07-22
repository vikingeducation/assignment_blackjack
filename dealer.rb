require './player'

class Dealer < Player


  def hit(cards)
    until hand_value >= 17
      draw
    end
  end

  def hand_value
    aces = 0
    values = @hand.map{ |card| card[0] }
    sum = values.inject (0) do |total, value|
      value = 13 ? aces += 1 : total + [value, 10].min
    end

    if aces > 0
      remaining = aces - 1
      high_sum = sum + remaining + 11
      # soft 17 edge case
      if high_sum == 17
        sum + remaining + 1 
      elsif high_sum > 17 && high_sum <= 21 
        high_sum 
      else
        sum + aces
      end
    end

  end

end

    #the dealer also hits on a "soft" 17, i.e. a hand containing an ace and one or more other cards totaling six.) 
# also what if a hand contains two aces?