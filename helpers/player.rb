# ./helpers/player.rb

module BlackjackHelpers
  class Player
    attr_accessor :hand,
                  :balance

    def initialize(hand = nil, balance = nil)
      @hand = hand || []
      @balance = balance || 1000
    end
  end
end
