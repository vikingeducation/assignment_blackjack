class Player
  attr_accessor :bankroll

  # track bankroll

  def initialize(bankroll = 1000)
    @bankroll = bankroll
  end

  # validate bet
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


  # draw card

  # hand

  # calc total

  # hit

  # stay

  # has_blackjack?

  # busted?

  # < dealer hit/stay

end