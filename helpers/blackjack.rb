class Blackjack

  CARD_ARRAY = ['Ace', 'King', 'Queen', 'Jack', ('2'..'10').to_a].flatten

  def initialize(deck=nil, player_cards=nil, dealer_cards=nil)
    @deck = deck || create_deck
    @player_cards = player_cards || Array.new
    @dealer_cards = dealer_cards || Array.new
  end

  def shuffle

  end

  def create_deck
    @deck = []
    4.times do
      @deck += CARD_ARRAY
    end
  end
end