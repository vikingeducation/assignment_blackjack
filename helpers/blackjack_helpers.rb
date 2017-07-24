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

  def restore_variables
    restore_user
    restore_dealer
    restore_deck
  end


  def get_scores(user, dealer)
    @user_score = user.get_score
    @dealer_score = dealer.get_score
  end


  def dealers_turn(dealer)
    while @dealer_score <= 17
      @dealer.hand << @deck.deal_cards(1).flatten
      @dealer_score = @dealer.get_score
    end
  end

  private

  def restore_deck
    @deck = session[:deck]
  end


  def restore_user
    @user = HumanPlayer.new(session[:user_hand], session[:user_bankroll], session[:user_bet])
  end


  def restore_dealer
    @dealer = Player.new(session[:dealer_hand])
  end


end
