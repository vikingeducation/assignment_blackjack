class Deck

  attr_reader :cards

  def initialize(cards = nil)
    cards ||= new_deck
    @cards = cards
  end


  def new_deck
    suits = ["S", "C", "D", "H"]
    values = (2..14).to_a
    values *= 4
    deck = []
    values.product(suits) { |result| deck << result }
    deck
  end


end