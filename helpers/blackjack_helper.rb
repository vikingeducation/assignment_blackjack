module BlackjackHelper
  def deal(deck, num)
    deck.pop(num)
  end

  def state(cards)
    case calc_value(cards)
    when calc_value(cards) > 21
      :busted
    when calc_value(cards) == 21 && cards.length == 2
      :blackjack
    else
      calc_value(cards)
    end
  end

  def final_result(dealer_cards, player_cards)
    dealer_state = state(dealer_cards)
    player_state = state(player_cards)
    if dealer_state == player_state
      "It was a tie!!"
    elsif player_state == :busted
      "You lost!"
    elsif dealer_state == :blackjack
      "The dealer had blackjack! You lose..."
    elsif player_state == :blackjack
      "You had blackjack, you win!"
    elsif player_state < dealer_state
      "You lose..."
    elsif dealer_state < player_state
      "You win!"
    end
  end

  def cards_total(cards)
    cards.map do |card|
      if card[0].is_a?(Integer)
        card[0]
      elsif card[0] == :ace
        11
      else
        10
      end
    end.reduce(:+)

  end

  def correct_for_aces(cards, total)
    num_of_aces(cards).times do
      total -=10 if total > 21
    end
    total
  end

  def calc_value(cards)
    total = cards_total(cards)
    correct_for_aces(cards, total)
  end

  def bust?(cards)
    total_value = calc_value(cards)
    if total_value > 21 
      true
    elsif total_value <= 21
      false
    end
  end

  def no_aces?(cards)
    !cards.map { |card| card[0] }.any? { |card| card == :ace }
  end

  def num_of_aces(cards)
    cards.select { |card| card[0] == :ace }.length
  end

  def new_deck
    return_array = []
    ranks.product(suits)
  end

  def ranks
    (2..10).to_a << :ace << :jack << :queen << :king
  end

  def suits
    [:spade, :heart, :diamond, :club]
  end
end
