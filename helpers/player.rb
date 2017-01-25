class Player
  attr_accessor :bankroll

  def initialize(bankroll: nil)
    @bankroll = bankroll || 1000.0
  end

  def valid_bet?(num)
    return true if num >= 5 && num % 5 == 0 && num <= @bankroll
    false
  end
end