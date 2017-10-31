module BlackjackHelper

  BLACKJACK = 21

  def display_card(card)
    "#{card[0]} of #{card[1]}"
  end

  def build_deck
    suits = %w(Hearts Diamonds Clubs Spades)
    numbers = (2..10).to_a.unshift('A').push(%w(J Q K)).flatten
    numbers.product(suits).shuffle
  end

  def calculate_hand(hand)
    hand.reduce(0) do |memo, card|
      value = if card[0].class == Integer
        card[0]
      elsif %w(J Q K).include?(card[0])
        10
      else
        1
      end
      memo + value
    end #hand
  end

  def game_ending_hand?(hand)
    busted?(hand) || blackjack?(hand)
  end

  def busted?(hand)
    hand > BLACKJACK
  end

  def blackjack?(hand)
    hand == BLACKJACK
  end

  def determine_winner(dealer, player)
    if dealer == player
      'Dealer. You forfeited.'
    elsif busted?(player) || (dealer > player && dealer <= BLACKJACK)
      'Dealer'
    elsif busted?(dealer) || (player > dealer && player <= BLACKJACK)
      'You'
    else
      'No winner'
    end
  end

  def display_winner(winner)
    "The winner is: #{winner}"
  end

end