# ./helpers/player.rb

module BlackjackHelpers
  class Player
    attr_accessor :hand

    attr_reader :balance,
                :bet

    def initialize(options = {})
      @hand = options[:hand] || []
      @balance = options[:balance] || 1000
      @bet = options[:bet] || 0
    end

    # places a bet
    def place_bet(bet)
      @bet = bet
      @balance -= bet
    end
  end
end
