class Player

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def sum
    values = @cards.map { |card| card.value }
    sum = 0
    values.each do |value|
      if value == "A"
        sum += 1
      elsif value.to_i == 0
        sum += 10
      else
        sum += value.to_i
      end
    end
    values.each do |value|
      sum += 10 if elevent_point_ace?(value, sum)
    end
    sum
  end

  def elevent_point_ace?(value, sum)
    value == "A" && sum < 12
  end

end