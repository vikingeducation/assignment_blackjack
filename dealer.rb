class Dealer

  attr_reader :cards

  def initialize(cards=[], deck, player)
    @cards, @deck, @player = cards, deck, player
  end

  def deal_cards
    2.times do
      @player.cards << @deck.pop
      @cards << @deck.pop
    end
  end

  def deal_to_player
    @player.cards << @deck.pop
  end

  def get_total(busted)
    if busted
      return total_points
    else
      points = total_points
      until points >= 17
        @cards << @deck.pop
        points = total_points
      end
      return points
    end
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
