module BlackjackHelper
  def deal(deck, num)
    deck.pop(num)
  end

  def new_deck
    return_array = []
    ranks.product(suits)
  end

  def ranks
    (2..10).to_a << :ace << :jack << :queen << :king
  end

  def suits
    [:spade, :heart, :diamond, :club]
  end
end
