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

  # save Player state to session
  def save_player(player)
    session[:player_hand] = player.hand
    session[:player_balance] = player.balance
    session[:player_bet] = player.bet
  end

  # load Player state from session
  def load_player
    Player.new(hand: session[:player_hand], balance: session[:player_balance], bet: session[:player_bet])
  end

  # save remaining cards in deck to session
  def save_cards(cards)
    session[:cards] = cards
  end

  # load saved cards from session
  def load_cards
    Blackjack.new(session[:cards])
  end

  # clear required session state for next round
  def next_round
    session[:dealer_hand] = nil
    session[:player_hand] = nil
    session[:cards] = nil
  end
end
