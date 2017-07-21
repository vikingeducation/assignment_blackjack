require_relative 'deck'
require_relative 'player'

module BlackJackHelpers


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


end
