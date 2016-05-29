class Deck
  attr_reader :deck
  def initialize
    @deck = ("2".."10").to_a + %w(J Q K A)
    @deck = @deck.product(%w(C S H D)).shuffle
  end
end
