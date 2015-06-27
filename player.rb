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


  # draw card

  # hand

  # calc total

  # hit

  # stay

  # has_blackjack?

  # busted?

  # < dealer hit/stay

end