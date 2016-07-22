require './player'

class Dealer < Player


  def hit(cards)
    until hand_value >= 17
      draw
    end
  end
  
end