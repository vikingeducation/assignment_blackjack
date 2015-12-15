class Player
  attr_reader :bankroll

  def initialize(bankroll = 1000)
    @bankroll = bankroll
  end
end