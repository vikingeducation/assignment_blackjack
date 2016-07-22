class Hand

  attr_reader :player_hand, :dealer_hand
  def initialize(deck, player_hand=nil, dealer_hand=nil)
    @deck = deck   #dealer and and players hand
    if player_hand
      @player_hand = player_hand
    else
      @player_hand = []
    end
    if dealer_hand
      @dealer_hand = dealer_hand
    else
      @dealer_hand = []
    end
    #@both_players_hands = [@players_hand, @dealers_hand]
  end

  def deal_cards
    2.times do 
      @player_hand << @deck.pop
      @dealer_hand << @deck.pop
    end
  end

  def sum_of_cards(hand)
    card_values = hand.map do |card|
      if card >= 11
        card = 10
      else
        card
      end
    end
    card_values.reduce(:+)
  end

  def player_hit(player_hand)
    player_hand << @deck.pop 
  end

  def dealer_hit(dealer_hand)
    dealer_hand << @deck.pop
  end

end