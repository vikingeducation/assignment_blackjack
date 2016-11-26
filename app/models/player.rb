
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
      value = hand.reduce(0) do |total, card|
        total += card.value
      end
      offset_aces(value)
    end

    def offset_aces(value)
      aces_to_offset = aces.length
      while value > 21 && aces_to_offset > 0
        value -= 10
        aces_to_offset -= 1
      end
      value
    end

    def aces
      hand.select { |card| card.rank == 'Ace' }
    end

    def bust?
      hand_value > 21
    end

  end
end
