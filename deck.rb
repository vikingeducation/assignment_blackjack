class Deck

  attr_reader :cards
  def initialize(cards = nil)
    suits = ['H', 'D', 'S', 'C']
    values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    cards.nil? ? @cards = suits.product(values).shuffle! : @cards = cards
  end

  def pop
    cards.pop
  end
end