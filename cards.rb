class Cards

  attr_reader :deck

  def initialize
    @card_value = (1..13).to_a
    @suits = ['hearts', 'spades', 'clubs', 'diamonds']
    @deck = @card_value.product(@suits).shuffle
  end

  def pick_card
    @deck.pop
  end



end
