class Player

  attr_accessor :bankroll, :hand, :bet

  def initialize(bankroll = 500)
    @bankroll = bankroll
    @hand = []
    @bet = 0
  end

  def has_bankroll?(bet_amount)
    @bankroll - bet_amount > 0
  end
end
