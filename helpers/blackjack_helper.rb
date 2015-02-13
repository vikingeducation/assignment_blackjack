module BlackjackHelper
  def value(hand)
    if hand.count(:A) > 0
      hand_with_aces_counter(hand)
    else
      aceless_hand_counter(hand)
    end
  end

  def aceless_hand_counter(hand)
    hand.inject(0) do |sum, card|
      sum += value_of card
    end
  end

  def hand_with_aces_counter(hand)
    num_of_aces = hand.count(:A)
    base_value = aceless_hand_counter(hand - [:A])
    value_including_aces(base_value, num_of_aces)
  end

  def value_of(card)
    if [:J,:Q,:K].include? card
      10
    else
      card
    end
  end

  def value_including_aces(base_value,num_of_aces)
    base_value += num_of_aces
    if base_value <= 11
      base_value += 10
    end
    base_value
  end
end