class Deck
  attr_accessor :cards

  def initialize cards = []
    @cards = cards.empty? ? random_cards : cards
  end

  def random_cards
    cards = ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'] * 4
    cards.shuffle
  end

  def deal_card people
    people.cards << @cards.pop
  end
end
