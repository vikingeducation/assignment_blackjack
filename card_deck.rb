class CardDeck
  attr_reader :deck_arr, :player_hand, :dealer_hand

  def initialize(deck_arr = nil)
    if deck_arr
      @deck_arr = deck_arr
    else
      @deck_arr = build_deck.shuffle
    end
  end

  def deal(deck_arr)
    @player_hand = [deck_arr.pop, deck_arr.pop]
    @dealer_hand = [deck_arr.pop, deck_arr.pop]
    @deck_arr = deck_arr
  end

  def hit(hand)
    hand << deck_arr.pop
    hand
  end

  def hand_values(hand)
    values = [0]

    hand.each do |card|
      if card.first == 'A'
        lows = values.map{|val| val += 1}
        highs = values.map{|val| val += 11}
        values = lows + highs
      else
        if ['J', 'Q', 'K'].include?(card.first)
          amount = 10
        else
          amount = card.first
        end
        values.map!{|val| val += amount}
      end
    end

    values
  end

  def bust?(values)
    values.all?{|val| val > 21}
  end

  private

  def build_deck
    suits = ['hearts', 'diamonds', 'spades', 'clubs']
    values = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']
    values.product(suits)
  end
end