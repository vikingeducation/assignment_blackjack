Card = Struct.new(:value, :suit)

class Deck

  attr_accessor :cards

  def initialize(cards=nil)
    @cards = cards ? cards : new_deck
  end

  def new_deck
    values = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
    suits = %w(spades hearts diamonds clubs)
    cards = values.product(suits)
    cards.map { |value, suit| Card.new(value, suit) }.shuffle
  end

  def shuffle
    @cards.shuffle
  end

  def deal_hand
    hand = []
    2.times { hand << @cards.pop }
    hand
  end

  def hit
    @cards.pop
  end

end

