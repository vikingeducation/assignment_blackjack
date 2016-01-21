class Blackjack

  def initialize
    @deck = Cards.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def deal(user)
    user.hand << @deck.pick_card
    user.hand << @deck.pick_card
  end

  def new_hand
    deal(@dealer)
    deal(@player)
  end

  def has_won?

  end

  def hit

  end

  def split

  end

  def stay

  end

end