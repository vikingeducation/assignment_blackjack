class Player
  attr_accessor :bankroll

  def initialize(bankroll = 1000)
    @bankroll = bankroll
  end

  def bet(amount = 50)
    @bankroll -= amount
    amount
  end

  def claim_prize(amount = 0)
    @bankroll += amount
  end

  def has_money?(amount)
    bankroll > amount
  end
end
