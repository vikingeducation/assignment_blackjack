class Hand

  attr_reader :cards

  def initialize(cards = [])
    @cards = cards
  end

  # add_card, count value, see_cards,
  # ace logic: 11, subtract until <21

  def ace_logic(value, aces)
    while value > 21 && aces > 0
      value -= 10
      aces -= 1
    end
    value
  end

  def hand_value
    value = 0
    aces = 0
    cards.each do |card|
      aces += 1 if card.value == 11
      value += card.value
    end
    value = ace_logic(value, aces)
  end

  def add_card
    @cards << @deck.
  end


end
