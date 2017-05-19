# ./helpers/blackjack_helpers.rb

module BlackjackHelpers
  # save cards in dealer hand to session
  def save_dealer(dealer_hand)
    session[:dealer_hand] = dealer_hand
  end

  # load dealer hand from session
  def load_dealer
    Dealer.new(session[:dealer_hand])
  end

  # save cards in player hand to session
  def save_player(player_hand)
    session[:player_hand] = player_hand
  end

  # load player hand from session
  def load_player
    Player.new(session[:player_hand])
  end

  # save remaining cards in deck to session
  def save_cards(cards)
    session[:cards] = cards
  end

  # load saved cards from session
  def load_cards
    Blackjack.new(session[:cards])
  end

  # reset game for next round
  def reset_game
    session[:dealer_hand] = nil
    session[:player_hand] = nil
    session[:cards] = nil
  end
end
