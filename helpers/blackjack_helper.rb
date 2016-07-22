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

  def save_game(game)
    state = game.save
    session["player"] = state["player"]
    session["dealer"] = state["dealer"]
  end


end
