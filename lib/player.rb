class Player
  attr_accessor :hand
  def initialize(hand=nil)
    @hand = hand ? JSON.parse(hand) : []
  end

  def sum
    sum = 0
    ace = false
    @hand.each do |card|
      if card[0] == 'ace'
        ace = true
      elsif card[0] == 'king' || card[0] == 'jack' || card[0] == 'queen'
        sum += 10
      else
        sum += card[0].to_i
      end
    end
    if ace
      sum = sum + 11 < 21 ? sum + 11 : sum + 1
    end
    sum
  end
end

class AI < Player
  def enough?
    self.sum >= 17
  end
end
