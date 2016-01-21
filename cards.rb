class Cards

  attr_reader :deck

  def initialize(player_hand = [], dealer_hand = [])
    @player_hand = player_hand
    @dealer_hand = dealer_hand
    @card_value = (1..13).to_a
    @suits = ['hearts', 'spades', 'clubs', 'diamonds']
    @deck = @card_value.product(@suits).shuffle
    update_deck
  end

  def pick_card
    @deck.pop
  end

  def update_deck
    player_hand.each {|card| @deck.delete(card)}
    dealer_hand.each {|card| @deck.delete(card)}
  end



end
