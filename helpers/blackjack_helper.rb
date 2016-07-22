module BlackjackHelper

  def get_player_hand
    session["player"]
  end

  def get_dealer_hand
    session["dealer"]
  end


end
