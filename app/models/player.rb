
module Blackjack
  class Player
    attr_reader :hand

    def initialize(args = {})
      @hand = args.fetch(:hand, [])
    end

    def hand_view
      hand.map do |card|
        card.front
      end.join(', ')
    end

    def hand_value
      hand.reduce(0) do |total, card|
        total += card.value
      end
    end

  end
end
