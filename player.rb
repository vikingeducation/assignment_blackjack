class Player
  attr_reader :cards

  def initialize(cards=[])
    @cards = cards
  end

  def total_points
    total = [0,0]
    @cards.each do |card|
      if card[0].to_i > 0
        total[0] = total[1] += card[0].to_i
      elsif card[0] == "A"
        total[0] += 1
        total[1] += 11
      else
        total[0] = total[1] += 10
      end
    end
    if total[1] > 21
      return total.min
    else
      return total.max
    end
  end

end
