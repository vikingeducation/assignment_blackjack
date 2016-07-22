class Deck

  def initialize
    @cards = new_deck
  end


  def new_deck
    suits = ["S", "C", "D", "H"]
    values = (1..13).to_a
    values *= 4
    deck = []
    values.product(suits) { |result| deck << result }
    deck
  end


end