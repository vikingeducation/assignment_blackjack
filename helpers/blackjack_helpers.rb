require_relative 'deck'
require_relative 'player'

module BlackJackHelpers

  # SCORES = {
  #   '2' => 2,
  #   '3' => 3,
  #   '4' => 4,
  #   '5' => 5,
  #   '6' => 6,
  #   '7' => 7,
  #   '8' => 8,
  #   '9' => 9,
  #   '10' => 10,
  #   'J' => 10,
  #   'Q' => 10,
  #   'K' => 10,
  #   'A' => 11
  # }

  # def save_variables
  #   session[:dealer] = @dealer
  #   session[:player] = @user
  #   session[:deck] = @deck
  # end

  def save_variables
    session[:dealer_hand] = @dealer.hand
    session[:player_hand] = @user.hand
    session[:deck] = @deck
  end

  def restore_deck
    @deck = session[:deck]
  end

  def restore_player
    @user = Player.new(session[:player_hand])
  end

  def restore_dealer
    @dealer = Player.new(session[:dealer_hand])
  end

  # def get_player_score(player)
  #   score = player.reduce(0) do |s, i|
  #     s += SCORES[i[0].to_s]
  #   end
  #   if score > 21 && player.any? {|x| x[0] == "A"}
  #     score = score - 10
  #   end
  #   score
  # end


end
