require_relative 'human.rb'
class Dealer < Human

  def over_17?
    cards_sum > 17
  end

end
