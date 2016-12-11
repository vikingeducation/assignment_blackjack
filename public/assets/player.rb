class Player
  attr_reader :hand, :hi, :low
  def initialize(current = [])
    @hand = current.empty? ? [] : current
    @hi = 0
    @low = 0
  end

  def hand_sum
    @hi = 0
    @low = 0
    @hand.each do |card|
      if card[0] == 1
        @hi += 11
        @low += 1
      elsif (10..13).to_a.include?(card[0])
        @hi += 10
        @low += 10
      else
        @hi += card[0]
        @low += card[0]
      end
    end
  end

  def bust?
    @low > 21
  end
end