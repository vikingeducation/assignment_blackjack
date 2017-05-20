# ./helpers/player.rb

module BlackjackHelpers
  class Player
    attr_accessor :hand

    attr_reader :balance,
                :current_bet

    def initialize(options = {})
      @hand = options[:hand] || []
      @balance = options[:balance] || 1000
      @current_bet = options[:current_bet] || 0
    end

    # places a bet
    def place_bet(bet)
      @current_bet = bet
      @balance -= bet
    end
  end
end
