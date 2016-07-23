# helpers/deck.rb

class Deck
  attr_reader :deck

  SUITS = %w{Spades Diamonds Hearts Clubs}
  RANKS = ("2".."10").to_a + %w{Jack King Queen Ace}

  def initialize(deck = SUITS.product(RANKS).shuffle)
    @deck = deck
  end

  def size
    @deck.length
  end

  def deal
    [deal_one_card, deal_one_card]
  end

  def hit
    deal_one_card
  end

  def push(card)
    @deck << card
  end

  def empty?
    @deck.empty?
  end

  private

  def deal_one_card
    @deck.pop unless empty?
  end

end
