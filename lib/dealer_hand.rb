require_relative "hand"

class DealerHand < Hand
  def initialize(hand_arr = [])
    @hand_arr = hand_arr
  end

  def get_moves
     @hand_arr.hit until score < 17
     @hand_arr
  end
end