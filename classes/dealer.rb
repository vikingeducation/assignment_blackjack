

class Dealer < Hand

  def decide
    add_card until hand_value > 16
  end

end
