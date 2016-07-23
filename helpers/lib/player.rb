class Player
  attr_reader :name
  def initialize(options = {})
    @hand = Hand.new
    @doubled_down = false
  end

  def doubled_down?
    @doubled_down
  end

  def bust?
    @hand.bust?
  end

  def remove_card_from_hand
    @hand.remove_card
  end

  def add_card_to_hand(card)
    @hand.add_card(card)
  end

  def twenty_one?
    @hand.total_value == 21
  end

  def hand_value
    @hand.total_value
  end

  def cards_in_hand
    @hand.cards
  end
end
