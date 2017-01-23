class Player
  attr_accessor :bankroll

  def initialize(bankroll: nil)
    @bankroll = bankroll || 1000
  end
end