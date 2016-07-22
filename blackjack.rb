class Blackjack

  attr_reader :deck, :dealer, :player

  def initialize(deck = nil, player_hand = nil, dealer_hand = nil)

    @deck = Deck.new(deck)
    @dealer = Dealer.new(dealer_hand)
    @player = Player.new(player_hand)
  end

  def start
    shuffle
    first_draw
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

  def game_over?(hand)
    @player.bust?(hand) || @player.blackjack?(hand)
  end

  def dealer_wins?(player_hand, dealer_hand)
    return true if dealer_hand > player_hand && dealer_hand <= 21
  end
  
end




