class Player

  attr_accessor :hand

  def initialize(hand)
    @hand = hand
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


class HumanPlayer < Player

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


  def payout(user_score, dealer_score)
    if dealer_score > 21 ||
      (dealer_score < 21 && dealer_score < user_score && user_score < 21) ||
      user_score == 21
      self.bankroll += (self.bet * 2)
    elsif dealer_score == user_score
      self.bankroll += self.bet
    end
  end


end


class Dealer < Player

  attr_accessor :hand

  def initialize(hand)
    @hand = hand
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

  def partial_hand
    [["HIDDEN"], self.hand.slice(1, self.hand.length).flatten]
  end

  def partial_hand_score(array)
    array.shift
    score = array.reduce(0) do |s, i|
      s += @scores[i[0].to_s]
    end
  end


end
