class Player
  attr_accessor :hand, :bank, :bet, :status
  def initialize(opts=nil)
    opts = opts ? JSON.parse(opts) : {}
    @hand = opts['hand'] ? opts['hand'] : []
    @bank = opts['bank'] ? opts['bank'] : 1000
    @bet = opts['bet'] ? opts['bet'] : 0
    @status = opts['status']
  end

  def sum
    sum = 0
    ace = false
    @hand.each do |card|
      if card[0] == 'A'
        ace = true
      elsif card[0] == 'K' || card[0] == 'J' || card[0] == 'Q'
        sum += 10
      else
        sum += card[0].to_i
      end
    end
    if ace
      sum = sum + 11 <= 21 ? sum + 11 : sum + 1
    end
    sum
  end

  def blackjack?
    self.sum == 21
  end

end

class AI < Player
  def enough?
    self.sum >= 17
  end
end
