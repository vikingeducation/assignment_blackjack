class Human
  attr_accessor :cards

  def initialize cards = []
    @cards = cards
  end

  def cards_sum
    big_result = a_map_big.inject(&:+)
    small_result = a_map_small.inject(&:+)
    return big_result > 21 ? small_result : big_result
  end

  def a_map_small
    @cards.map do |card|
      case card
      when 'A' then 1
      when 'J' then 10
      when 'Q' then 10
      when 'K' then 10
      else
        card
      end
    end
  end

  def a_map_big
    @cards.map do |card|
      case card
      when 'A' then 11
      when 'J' then 10
      when 'Q' then 10
      when 'K' then 10
      else
        card
      end
    end
  end

  def bust
    cards_sum > 21
  end

end
