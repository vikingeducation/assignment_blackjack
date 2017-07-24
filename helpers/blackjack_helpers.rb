require_relative 'deck'
require_relative 'player'

module BlackJackHelpers


  def save_variables
    session[:dealer_hand] = @dealer.hand
    session[:user_hand] = @user.hand
    session[:user_bankroll] = @user.bankroll
    session[:user_bet] = @user.bet
    session[:deck] = @deck
  end


  def restore_deck
    @deck = session[:deck]
  end


  def restore_user
    @user = Player.new(session[:user_hand], session[:user_bankroll], session[:user_bet])
  end


  def restore_dealer
    @dealer = Player.new(session[:dealer_hand])
  end


end
