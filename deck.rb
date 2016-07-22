class Deck

  attr_reader :deck

  def initialize(prev_deck = nil)
    @deck = prev_deck || generate_deck
  end

  def generate_deck
    ranks = %w(2 3 4 5 6 7 8 9 10 J Q K A)
    suits = %w(C D H S)
    deck = []
    ranks.each do |rank|
      suits.each { |suit| deck << rank + suit }
    end
    deck.shuffle
  end

end
