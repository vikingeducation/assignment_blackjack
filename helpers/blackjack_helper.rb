module BlackjackHelper

  def make_blackjack
    Blackjack.new(get_player_hand, get_dealer_hand, get_bank)
  end

  def get_player_hand
    session["player"]
  end

  def get_dealer_hand
    session["dealer"]
  end

  def get_player_score
    session["player_score"]
  end

  def get_dealer_score
    session["dealer_score"]
  end

  def get_bet
    session["bet"].to_i
  end

  def get_bank
    session["bank"].to_i
  end

  def enough_money?(bet)
    bet ||= 0
    session["bank"].to_i >= bet.to_i
  end


  def save_game(game)
    state = game.save
    session["player"] = state["player"]
    session["dealer"] = state["dealer"]
    session["bank"] = game.player_hand.bank
    session["player_score"] = game.player_hand.hand_value
    session["dealer_score"] = game.dealer_hand.hand_value
  end
end
