require 'forwardable'

module Blackjack

  class Card

    attr_reader :front, :rank, :suit, :value

    def initialize(args = {})
      @rank   = args.fetch(:rank)
      @suit   = args.fetch(:suit)
      @front  = "#{ rank } of #{ suit }s"
      @value  = args.fetch(:value)
    end

  end

  class Deck

    attr_reader :cards

    extend Forwardable

    def_delegator :cards, :each

    CARD_FACTORY = Card

    def initialize
      @cards = Deck.generate_cards
    end

    protected

      def self.generate_cards
        cards = []
        suits.each do |suit|
          ranks.each do |rank|
            cards << CARD_FACTORY.new(rank: rank,
                                      suit: suit,
                                      value: value(rank))
          end
        end
        cards
      end

    private

      def self.rank_values
        { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 =>7,
          8 => 8, 9 => 9, 10 => 10, "Jack" => 10,
          "Queen" => 10, "King" => 10, "Ace" => 11 }
      end

      def self.ranks
        rank_values.keys
      end

      def self.suits
        ["♠", "♥", "♦", "♣"]
      end

      def self.value(rank)
        rank_values[rank]
      end
  end
end
