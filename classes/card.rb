# suit, number, value

class Card

  attr_reader :suit, :face

  def initialize(suit, face)
    @face = face
    @suit = suit
  end

  def value
    Blackjack::VALUES[@face]
  end


end
