module BlackjackHelper
  def load_deck
    CardDeck.new({:created => JSON.parse( session[:deck])})
  end

  def load_player
    Player.new({:created => JSON.parse( session[:player])})
  end

  def load_dealer
    Player.new({:created => JSON.parse( session[:dealer])})
  end

  def save_deck(card_deck)
    session[:deck] = card_deck.deck.to_json
  end

  def save_player(player_hand)
    session[:player] = player_hand.deck.to_json
  end

  def save_dealer(dealer_hand)
    session[:player] = dealer_hand.deck.to_json
  end
end