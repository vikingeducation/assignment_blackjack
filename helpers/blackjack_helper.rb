module BlackjackHelper

  def make_blackjack
    Blackjack.new(get_player_hand, get_dealer_hand)
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
    session["bet"]
  end

  def get_bank
    session["bank"]
  end


  def save_game(game)
    state = game.save
    session["player"] = state["player"]
    session["dealer"] = state["dealer"]
    session["bank"] = game.player_hand.bank
    # session["player"] = state["player_score"]
    # session["dealer"] = state["dealer_score"]
  end


end
