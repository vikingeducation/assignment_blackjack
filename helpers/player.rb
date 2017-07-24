class Player

  attr_accessor :hand, :bankroll, :bet

  def initialize(hand, bankroll=1000, bet=0)
    @hand = hand
    @bankroll = bankroll
    @bet = bet
    @scores = {
      '2' => 2,
      '3' => 3,
      '4' => 4,
      '5' => 5,
      '6' => 6,
      '7' => 7,
      '8' => 8,
      '9' => 9,
      '10' => 10,
      'J' => 10,
      'Q' => 10,
      'K' => 10,
      'A' => 11
    }
  end

  def get_score
    score = @hand.reduce(0) do |s, i|
      s += @scores[i[0].to_s]
    end
    if score > 21 && @hand.any? {|x| x[0] == "A"}
      score = score - 10
    end
    score
  end


end
