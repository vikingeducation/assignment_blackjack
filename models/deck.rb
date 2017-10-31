class Deck

  FACE_CARDS = %w(Jack Queen King)

  def build_deck
    suits = %w(Hearts Diamonds Clubs Spades)
    numbers = (2..10).to_a.unshift('Ace').push(FACE_CARDS).flatten
    numbers.product(suits).shuffle
  end

end