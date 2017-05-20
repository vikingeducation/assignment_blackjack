# ./helpers/player.rb

module BlackjackHelpers
  class Player
    attr_accessor :hand

    def initialize(hand = nil)
      @hand = hand || []
    end
  end
end
