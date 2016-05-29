module BJHelpers #teehee!

  def save_state(deck, player, dealer)
    session[:deck] = deck.to_json
    session[:player] = player.to_json
    session[:dealer] = dealer.to_json
  end

  def get_cards
    JSON.parse(session[:deck])
  end

  def get_player_cards
    JSON.parse(session[:player])
  end

  def get_dealer_cards
    JSON.parse(session[:dealer])
  end

end
