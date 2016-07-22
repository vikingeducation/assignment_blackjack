
class Hand
  attr_reader :hand_arr

  def initialize(hand_arr=[])
    @hand_arr = hand_arr
  end

  def hit(card)
    @hand_arr << card
  end

  def stay
    @hand_arr
  end

  def score
    score_count = 0
    ace_count = 0
    return 0 if @hand_arr.empty?
    @hand_arr.each do |card|
      if card[0].to_i.between?(10,13)
        score_count += 10
      elsif card[0].to_i == 1
        score_count += 1
        ace_count += 1
      else
        score_count += card[0].to_i
      end

    end
    include_ace_bonus(score_count, ace_count)
  end

  def include_ace_bonus(score_count, ace_count)
    ace_count.times do
      break if (score_count + 10) > 21
      score_count += 10
    end
    score_count
  end

end