Card = Struct.new(:value, :suit)

class Deck

  attr_accessor :cards

  def initialize(deck=nil)
    @deck = deck ? deck : new_deck
  end

  def new_deck
    values = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
    suits = %w(spades hearts diamonds clubs)
    deck = values.product(suits)
    deck.map { |value, suit| Card.new(value, suit) }.shuffle
  end

  def shuffle
    @deck.shuffle
  end

  def deal_hand
    hand = []
    2.times { hand << @deck.pop }
    hand
  end

  def hit
    @deck.pop
  end

end

