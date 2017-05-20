# ./helpers/dealer.rb
module BlackjackHelpers
  class Dealer
    attr_accessor :hand

    def initialize(hand = nil)
      @hand = hand || []
    end
  end
end
