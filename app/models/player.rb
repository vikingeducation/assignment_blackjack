
module Blackjack
  class Player
    attr_reader :hand

    def initialize(args = {})
      @hand = args.fetch(:hand, [])
    end

  end
end
