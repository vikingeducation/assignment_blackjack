require_relative 'card'

class Deck
  attr_accessor :cards
  def initialize(deck = nil)
    if deck.nil?
      @cards = []
      populate
      shuffle!
    else
      @cards = deck
    end
  end

  def populate
    suits = %w(d c h s)
    values = %w(A 2 3 4 5 6 7 8 9 10 J Q K)

    suits.each do |suit|
      values.each do |value|
        @cards << Card.new(value, suit)
      end
    end
  end

  def shuffle!
    @cards.shuffle!
  end

  def pop
    @cards.pop
  end
end