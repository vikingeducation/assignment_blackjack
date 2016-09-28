module CardDeck

  def create_deck
    card_faces = [*1..13]
    card_suits = %w(Spade Heart Club Diamond)
    deck = card_suits.map do |suit|
      card_faces.map do |face|
        [face,suit]
      end
    end
    deck.flatten!(1)
  end
end