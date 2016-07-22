class Deck
  attr_reader :deck_arr

  def initialize(deck_arr = nil)
    @deck_arr = make_deck(deck_arr)
  end

  def deal
    @deck_arr.pop
  end

  private

    def  make_deck(deck_arr)
      if deck_arr.nil?
        deck_arr = (1..13).to_a * 4
        suits = %w(s) * 13 + %w(h) * 13 + %w(c) * 13 + %w(d) * 13

        deck_arr.map!.with_index do |card, index|
          card.to_s << suits[index]
        end

        deck_arr = deck_arr.shuffle
      end
      deck_arr
    end
end