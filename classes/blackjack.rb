require_relative 'card'
require_relative 'hand'

class Blackjack

  SUITS = ["H", "S", "C", "D"]

  VALUES = {
  "A": 11
  "2": 2
  "3": 3
  "4": 4
  "5": 5
  "6": 6
  "7": 7
  "8": 8
  "9": 9
  "10": 10
  "J": 10
  "Q": 10
  "K": 10
  }

  def initialize
    @deck = {}
    build_deck
  end

  def build_deck
    VALUES.keys.each do |key|
      @deck[key] = SUITS
    end
  end

  def give_card
    @deck[@deck.keys.sample]
  end



end
