class Player

  def initialize(hand)
    @hand = hand
  end

  def sum_if_11(hand)
    values = hand.map { |card| card.value }
    sum = 0
    values.each |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
    end
    sum > 21 ? sum : sum_if_1
  end

  def sum_if_1(hand)
    values = hand.map { |card| card.value }
    sum = 0
    values.each |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
    end
    sum
  end


end