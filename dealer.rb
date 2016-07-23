require './player'

class Dealer < Player


  def hit(cards)
    until hand_value(@hand) >= 17
      draw(cards)
    end
  end

  def hand_value(hand)
    aces = 0
    values = hand.map{ |card| card[0] }
    sum = 0
    values.each do |value|
      value == 13 ? aces += 1 : sum += [value, 10].min
    end

    if aces > 0
      remaining = aces - 1
      high_sum = sum + remaining + 11
      # soft 17 edge case
      
      return sum + remaining + 1  if high_sum == 17
      return  high_sum if high_sum > 17 && high_sum <= 21 
      
    end
    sum + aces
  end

end

    #the dealer also hits on a "soft" 17, i.e. a hand containing an ace and one or more other cards totaling six.) 
# also what if a hand contains two aces?