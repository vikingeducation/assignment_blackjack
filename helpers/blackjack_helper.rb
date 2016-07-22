module BlackjackHelper
  def deal(deck, num)
    deck.pop(num)
  end


  def calc_value(cards)
    cards.map do |card|
      if card[0].is_a?(Integer)
        card[0]
      elsif card[0] == :ace
        11
      else
        10
      end
    end.reduce(:+)
  end

  def bust?(cards)
    total_value = calc_value(cards)
    if total_value > 21 && no_aces?(cards)
      true
    elsif total_value < 21
      false
    else
      num_of_aces.times do
        total_value -= 10
      end
      total_value > 21
    end
  end

  def no_aces?(cards)
    !cards.map { |card| card[0] }.any? { |card| card == :ace }
  end

  def num_of_aces(cards)
    cards.select { |cards| card[0] == :ace }.length
  end

  def new_deck
    return_array = []
    ranks.product(suits)
  end

  def ranks
    (2..10).to_a << :ace << :jack << :queen << :king
  end

  def suits
    [:spade, :heart, :diamond, :club]
  end
end
