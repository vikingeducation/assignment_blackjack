

class Dealer < Hand

  def decide_hit?
    hand_value < 17
  end

end
