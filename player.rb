class Player

  attr_accessor :bankroll, :hand, :bet

  def initialize(bankroll = 500)
    @bankroll = bankroll
    @hand = []
  end

  def has_bankroll?(bet_amount)
    @bankroll - bet_amount >= 0
  end

  def make_bet(bet_amount)
    if has_bankroll?(bet_amount)
      @bankroll -= bet_amount
    else
      return false
    end
  end

end
