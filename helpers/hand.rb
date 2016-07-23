class Hand

CARDS = [1,2,3,4,5,6,7,8,9,10,11,12,13]
SUITS = ["c","d","h","s"]

  attr_reader :player_hand, :dealer_hand, :deck
  def initialize(deck=nil, player_hand=nil, dealer_hand=nil)
    
    if deck
      @deck = deck
    else
      @deck = []
      create_deck
    end   
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
  end

  #cards is an array of arrays 
  def create_deck
    @deck = CARDS.product(SUITS).shuffle
  end

  def deal_cards
    2.times do 
      @player_hand << @deck.pop
      @dealer_hand << @deck.pop
    end
  end

  def is_blackjack?(hand)
    ace_changer(hand) == 21
  end

#each card is an array such as [5, "c"]
  def sum_of_cards(hand)
    card_values = hand.map do |card|
      if card[0] == 1
        card[0] = 11
      elsif card[0] >= 11
        card[0] = 10
      else
        card[0]
      end
    end
    sum = 0
    card_values.each do |card|
      sum += card[0]
    end
    sum
  end

  def ace_changer(hand)
    hand_sum = sum_of_cards(hand)
    if has_card?(hand,1) && hand_sum > 21
      hand_sum -= 10
    end
    hand_sum
  end

  def has_card?(hand, value)
    values = []
    hand.each do |card|
      values << card[0]
    end
    values.include?(value)
  end


  def player_hit(player_hand)
    player_hand << @deck.pop 
  end

  def dealer_hit(dealer_hand)
    dealer_hand << @deck.pop
  end

end