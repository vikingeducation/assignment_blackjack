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
    sum = values.inject do |total, value|
      value = 13 ? aces += 1 : total + [value, 10].min
    end

    if aces == 1
      return sum + 1 if sum + 11 == 17
    elsif aces > 1
      # determine if 1 ace as '11' or none is better
      remaining = aces - 1
      high_sum = sum + remaining + 11
      return high_sum if high_sum > 17 && high_sum <= 21 

      sum + aces
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

    #the dealer also hits on a "soft" 17, i.e. a hand containing an ace and one or more other cards totaling six.) 
# also what if a hand contains two aces?