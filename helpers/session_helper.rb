module SessionHelper
  def new_game
    blackjack = Blackjack.new
    blackjack.first_deal
    session[:player_hand] = blackjack.player_hand.serialize
    session[:dealer_hand] = blackjack.dealer_hand.serialize
    blackjack
  end

  def load_session
    player_hand = Hand.deserialize(session[:player_hand])
    dealer_hand = Hand.deserialize(session[:dealer_hand])
    Blackjack.new(player_hand, dealer_hand)
  end

  def save_session(blackjack)
    session[:player_hand] = blackjack.player_hand.serialize
    session[:dealer_hand] = blackjack.dealer_hand.serialize
  end
end
