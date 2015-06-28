class Player
  attr_accessor :bankroll


  def initialize(bankroll = 1000)
    @bankroll = bankroll
  end


  def valid_bet?(bet)
    bet <= @bankroll
  end


  def payoff!(bet, win_message)
    if win_message.include?('Player')
      @bankroll += 2 * bet
    elsif win_message.include?('Push')
      @bankroll += bet
    end
  end

end