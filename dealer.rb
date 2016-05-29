class Dealer

  attr_reader :cards

  def initialize(cards=[], deck, player)
    @cards, @deck, @player = cards, deck, player
  end

  def deal_cards
    2.times do
      @player.cards << @deck.pop
      @cards << @deck.pop
    end
  end

end
