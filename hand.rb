class Hand
  attr_accessor :bet, :deck, :hands, :win_message

  # track bet, deck, hands, and winner

  def initialize(bet)
    @bet = bet

    # create new deck
    @deck = build_new_deck

    # deal cards
    @hands = deal_cards

    # reset winner
    @win_message = ""
  end


  private


  def build_new_deck
    ( ( (2..10).to_a + ["J","Q","K","A"] )*4 ).shuffle!
  end


  def deal_cards
    player_hand, dealer_hand = [0], [0]

    2.times do
      @player_hand << deck.pop
      @dealer_hand << deck.pop
    end

    [player_hand, dealer_hand]
  end


end