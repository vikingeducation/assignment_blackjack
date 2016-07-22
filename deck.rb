class Deck

  attr_reader :deck

  def initialize(prev_deck = nil)
    @deck = prev_deck || generate_deck
  end

  def generate_deck
    arr = %w(2 3 4 5 6 7 8 9 10 j q k a)
    deck = []
    4.times { deck << arr }
    deck.flatten.shuffle
  end


end
