class CardDeck
  attr_reader :deck, :player_hand, :dealer_hand

  def initialize(deck = nil)
    if deck
      @deck = deck
    else
      @deck = build_deck.shuffle
    end
  end

  def deal(deck)
    @player_hand = [deck.pop, deck.pop]
    @dealer_hand = [deck.pop, deck.pop]
    @deck = deck
  end

  private

  def build_deck
    suits = ['hearts', 'diamonds', 'spades', 'clubs']
    values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    deck = []

    suits.each do |suit|
      values.each do |value|
        deck << "#{value} #{suit}"
      end
    end

    deck
  end
end