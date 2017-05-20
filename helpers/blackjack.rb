module BlackjackHelpers
  class Blackjack
    attr_reader :cards

    def initialize(cards = nil)
      @cards = cards || generate_cards
    end

    # generates a standard 52 card deck
    def generate_cards
      suits = [:spades, :hearts, :clubs, :diamonds]
      values = (2..10).to_a
      values << [:ace, :jack, :queen, :king]
      values.flatten!

      values.product(suits).shuffle
    end

    # deals a card from the top of the deck
    def deal_card
      @cards.shift
    end

    # helper method to print out a card in a better-looking format
    def render(card)
      "#{card[0].to_s.capitalize} of #{card[1].to_s.capitalize}"
    end

    # calculates the points value of a hand
    def points(hand)
      points = 0

      hand.each do |card|
        case(card[0])
        when :ace
          points += 11
          points -= 10 if points > 21
        when :jack, :queen, :king
          points += 10
        else
          points += card[0]
        end
      end

      points
    end

    # checks if a hand is busted
    def busted?(hand)
      self.points(hand) > 21
    end

    # determines the winner of a round
    def winner(dealer_hand, player_hand)
      # check if either Dealer or Player has busted
      if busted?(dealer_hand) && busted?(player_hand)
        return :tie
      elsif busted?(dealer_hand) && !busted?(player_hand)
        return :player
      elsif !busted?(dealer_hand) && busted?(player_hand)
        return :dealer
      end

      # neither Dealer nor Player has busted, check points of hands
      if points(dealer_hand) == points(player_hand)
        return :tie
      elsif points(dealer_hand) > points(player_hand)
        return :dealer
      elsif points(dealer_hand) < points(player_hand)
        return :player
      end
    end
  end
end
