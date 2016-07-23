class Hand

  attr_reader :cards, :bank

# [[face, suit][face, suit]]

  def initialize(cards = [], bank = nil)
    @cards = get_cards(cards)
    bank ||= 1000
    @bank = bank
  end

  # add_card, count value, see_cards,
  # ace logic: 11, subtract until <21

  def get_cards(cards)
    cards.map { |card| Card.new(card[0], card[1])}
  end

  def make_bank(bet)
    @bank += bet
  end

  def lose_bank(bet)
    @bank -= bet
  end

  def ace_logic(value, aces)
    while value > 21 && aces > 0
      value -= 10
      aces -= 1
    end
    value
  end

  def hand_value
    value = 0
    aces = 0
    cards.each do |card|
      aces += 1 if card.value == 11
      value += card.value
    end
    value = ace_logic(value, aces)
  end

  def add_card(face, suit)
    @cards << Card.new(face, suit)
  end

  def busted?
    hand_value > 21
  end

end
