module BlackjackHelpers
  def save_deck(deck)
    session[:deck] = deck.to_json
  end

  def save_players_cards(players_cards)
    session[:players_cards] = players_cards.to_json
  end

  def save_dealers_cards(dealers_cards)
    session[:dealers_cards] = dealers_cards.to_json
  end

  def load_deck
    JSON.parse(session[:deck])
  end

  def load_players_cards
    JSON.parse(session[:players_cards])
  end

  def load_dealers_cards
    JSON.parse(session[:dealers_cards])
  end
end