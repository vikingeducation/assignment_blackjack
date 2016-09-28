module CardDeck

  def save_deck
    session["current_deck"] = create_deck
  end

  def load_deck
    session["current_deck"]
  end

  def place_card
    session["current_deck"].pop
  end

  def create_deck
    card_faces = [*1..13]
    card_suits = %w(Spade Heart Club Diamond)
    deck = card_suits.map do |suit|
      card_faces.map do |face|
        [face,suit]
      end
    end
    deck.flatten!(1).shuffle!
  end

end