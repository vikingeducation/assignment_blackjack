require_relative 'player'

class Dealer < Player
  def required_hit
    hand_sum < 17
  end
end