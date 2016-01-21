class Player

  attr_accessor :bankroll, :hand

  def initialize(bankroll = 500)
    @bankroll = bankroll
    @hand = []
  end


end