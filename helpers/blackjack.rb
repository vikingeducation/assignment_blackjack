class Blackjack

  CARD_ARRAY = ['Ace', 'King', 'Queen', 'Jack', ('2'..'10').to_a].flatten

  attr_accessor :deck, :player_cards, :dealer_cards 

  def initialize(deck=nil, player_cards=nil, dealer_cards=nil)
    @deck = deck || create_deck
    @player_cards = player_cards || Array.new
    @dealer_cards = dealer_cards || Array.new
    deal_cards
  end

  def shuffle

  end

  def create_deck
    @deck = []
    4.times do
      @deck += CARD_ARRAY
    end
    shuffle_deck
  end

  def shuffle_deck
    @deck.shuffle!
  end

  def deal_cards
    2.times do
      @player_cards << @deck.pop
    end

    2.times do
      @dealer_cards << @deck.pop
    end
  end  

  def sum_cards(cards)
    
    sum = 0
    @card.each do |card|
      when "King", "Queen", "Jack"
        sum += 10
      when ("2".."10").to_a.include?(card)
        sum += card.to_i
      end
    end  

    aces = cards.select {|card| card == "Ace"}
    aces.each do |ace|
      
      if sum += 11 > 21
         sum += 1
      else
         sum += 11
      end
    end  
    sum
  end


  def who_won?
    player_totals = sum_cards(@player_cards)
    dealer_totals = sum_cards(@pdealer_cards)

    if player_totals == 21
      "Player Wins!"
    elsif dealer_totals == 21
      "Dealer Wins"
    end  
  end    

end