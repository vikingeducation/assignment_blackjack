module BlackjackHelper

  def self.deal_hand(deck)
    #deal 2 random cards

    hand = []
    2.times do
      hand << deck.pop
    end
    hand
  end



end

  def create_deck
     cards = []
    4.times do
      (1..13).each do |n|
      cards << n
      end
    end
    cards.shuffle!
    return cards
  end