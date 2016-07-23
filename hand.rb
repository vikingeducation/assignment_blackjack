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

  def is_blackjack?
  end

#Aces considered 11 for now
  def sum_of_cards(hand)
    card_values = hand.map do |card|
      if card == 1
        card = 11
      elsif card >= 11
        card = 10
      else
        card
      end
    end
    card_values.reduce(:+)
  end

  def ace_changer(hand)
    hand_sum = sum_of_cards(hand)
    if hand.include?(1) && hand_sum > 21
      hand_sum -= 10
    end
    hand_sum
  end

  # def sum_of_cards(hard)
  #     card_values = hand.map do |card|
  #       if !hand.includes?(11..13)
  #         card_values.reduce(:+)
  #       elsif



  def player_hit(player_hand)
    player_hand << @deck.pop 
  end

  def dealer_hit(dealer_hand)
    dealer_hand << @deck.pop
  end

end