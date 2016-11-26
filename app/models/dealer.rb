
require File.expand_path('player', File.dirname(__FILE__))

module Blackjack
  class Dealer < Player

    def initialize(args = {})
      @deck = args.fetch(:deck)
      @opponent = args.fetch(:opponent)
      super
    end

    def hit
      while hand_value < 17 || opponent.hand_value > hand_value
        hand.concat(deck.draw(1))
      end
    end

    private
      attr_reader :deck, :opponent
  end
end
