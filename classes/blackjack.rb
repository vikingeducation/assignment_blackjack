require_relative 'card'
require_relative 'hand'
require_relative 'dealer'

class Blackjack
  #delete deck!
  attr_reader :player_hand, :dealer_hand, :deck

  SUITS = ["H", "S", "C", "D"]

  VALUES = {
  "A": 11,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
  "10": 10,
  "J": 10,
  "Q": 10,
  "K": 10
  }

  def initialize(player_hand = [], dealer_hand = [])
    @deck = {}
    @player_hand = Hand.new(player_hand)
    @dealer_hand = Dealer.new(dealer_hand)
    build_deck()
  end

  def build_deck
    VALUES.keys.each do |key|
      # don't add cards from hands
      @deck[key] = SUITS.dup
    end
  end

  def give_card(player)
    face = @deck.keys.sample
    suit = @deck[face].sample
    @deck[face].delete(suit)
    player.add_card(face, suit)
  end

  def finish
    return #dealer wins if @player_hand.busted?
    return #player wins if @dealer_hand.busted?
    return #player if @player_hand.hand_value > @dealer_hand.hand_value
    return #dealer hand
  end

end
