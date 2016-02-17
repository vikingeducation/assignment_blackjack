class Deck
  attr_reader :deck

  def initialize
    @deck = ('2'..'10').to_a + ['J','Q','K','A']
    @deck = @deck.product(['C','S','H','D']).shuffle
  end

end