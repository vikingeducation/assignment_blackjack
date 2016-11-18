module CardsHelper

  SUITS = ['clubs', 'diamonds', 'spades', 'hearts']

  DECK = {
            '2' => SUITS.dup, '3' => SUITS.dup, '4' => SUITS.dup,
            '5' => SUITS.dup, '6' => SUITS.dup, '7' => SUITS.dup,
            '8' => SUITS.dup, '9' => SUITS.dup, '10' => SUITS.dup,
            'J' => SUITS.dup, 'Q' => SUITS.dup, 'K' => SUITS.dup,
            'A' => SUITS.dup
          }

  def load_deck
    session["deck"] ||= generate_deck
  end

  def generate_deck
    deck = DECK.dup

    deck.each do |value, suits|
        deck[value] = suits.dup
    end
    deck
  end

  def draw_from_deck
    session["deck"] ||= load_deck
    value = session["deck"].keys.sample
    suit = session["deck"][value].shuffle!.pop

    session['deck'].delete(value) if session["deck"][value].empty?
    session['deck'] = nil if session['deck'].empty?

    [value, suit]
  end

  def pair_setup
    session["player2_cards"] = session["player_cards"][1]
    hit_me(session["player2_cards"])
    session["player_cards"].pop
    hit_me(session["player_cards"])
  end

  def save_cards(player_cards, dealer_cards)
    session["player_cards"] = player_cards
    session["dealer_cards"] = dealer_cards
  end
end
