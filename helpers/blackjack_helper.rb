module BlackjackHelper

  def deal_hand
    #create the deck
    cards = []
    4.times do
      (1..13).each do |n|
      cards << n
      end
    end
    #deal 2 random cards
    hand = []
    2.times do
      hand << cards.shuffle.pop
    end
    hand
  end



end