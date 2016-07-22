require_relative "hand"

class DealerHand < Hand
  def initialize(hand_arr = [])
    @hand_arr = hand_arr
  end
end