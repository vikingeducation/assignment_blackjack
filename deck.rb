class Deck

  def initialize(prev_deck = nil)
    @deck = prevdeck || generate_deck
  end

  def generate_deck
    arr = %w(2 3 4 5 6 7 8 9 10 j q k a)
    deck = []
    4.times { deck << arr }
    deck.flatten
  end

  def deal
  end

end
