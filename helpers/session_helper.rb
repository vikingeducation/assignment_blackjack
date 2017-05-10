module SessionHelper
  def new_game
    blackjack = Blackjack.new
    blackjack.first_deal
    session[:player_hand] = blackjack.player_hand.serialize
    session[:dealer_hand] = blackjack.dealer_hand.serialize
    session[:player_bet] = blackjack.player_bet
    session[:player_bankroll] = blackjack.player_bankroll
    blackjack
  end

  def new_round
    blackjack = Blackjack.new
    blackjack.first_deal
    session[:player_hand] = blackjack.player_hand.serialize
    session[:dealer_hand] = blackjack.dealer_hand.serialize
    session[:player_bet] = blackjack.player_bet
    blackjack
  end

  def load_session
    player_hand = Hand.deserialize(session[:player_hand])
    dealer_hand = Hand.deserialize(session[:dealer_hand])
    player_bet = session[:player_bet].to_i
    player_bankroll = session[:player_bankroll].to_i
    Blackjack.new(player_hand, dealer_hand, player_bankroll, player_bet)
  end

  def save_session(blackjack)
    session[:player_hand] = blackjack.player_hand.serialize
    session[:dealer_hand] = blackjack.dealer_hand.serialize
    session[:player_bet] = blackjack.player_bet
    session[:player_bankroll] = blackjack.player_bankroll
  end
end
