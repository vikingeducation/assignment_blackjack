class Blackjack

  attr_reader :deck, :dealer, :player

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new
  end

  def start
    shuffle
    first_draw
    @player.hit_or_stay?
  end

  def shuffle
    @deck.cards.shuffle!
  end

  def first_draw
    @dealer.draw(@deck.cards)
    @player.draw(@deck.cards)
    @dealer.draw(@deck.cards)
    @player.draw(@deck.cards)
  end

end