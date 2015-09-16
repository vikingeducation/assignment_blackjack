class Deck

  attr_reader :cards


  def initialize(state = nil)
    @cards = state.nil? ? build : state
  end

  
  def build
    values = (2..10).to_a + %w{J Q K A}
    suits = ["\u2660", "\u2665", "\u2666", "\u2663"]
    deck = values.product(suits)
    deck.shuffle
  end


  def deal_card
    @card.pop
  end
  
end

#checkmark = "\u2713"
#puts checkmark.encode('utf-8')
# "\u2660".encode('utf-8') - spade
# 2665 heart
# 2666 diamond
# 2663 club