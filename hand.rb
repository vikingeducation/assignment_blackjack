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


  def calc_hand_values!
    @hands.each { |player, cards| cards[0] = calculate(cards) }
  end


  private


  def build_new_deck
    ( ( (2..10).to_a + ["J","Q","K","A"] )*4 ).shuffle!
  end


  def deal_cards
    player_hand, dealer_hand = [0], [0]

    2.times do
      player_hand << deck.pop
      dealer_hand << deck.pop
    end

    { player: player_hand, dealer: dealer_hand }
  end


  def calculate(hand)
    values = get_card_values(hand)

    number_of_aces = hand.count("A")

    total = values.inject { |sum, card| sum += card }

    reduce_aces(total, number_of_aces)
  end


  def get_card_values(hand)
    # drop total @ index=0
    values = hand[1..-1]

    values.map! do |card|
      if %w[J Q K].include?(card)
        10
      elsif card == "A"
        11 # all Aces start as 11
      else
        card
      end
    end

    values
  end


  def reduce_aces(total, ace_count)
    aces_at_11 = ace_count

    until total <= 21 || aces_at_11 < 1
      total -= 10
      aces_at_11 -= 1
    end

    total
  end


end