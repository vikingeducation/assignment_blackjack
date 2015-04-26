module HandHelper

  def value_of_hand(cards)
    sum = 0
    cards.each { |card| sum += value_of_card(card) }
    return sum
  end

  def value_of_card(card)
    if [:J, :K, :Q].include?(card)
      return 10
    else
      return card
    end
  end

  def lost?
    value_of_hand(session[:player_hand]) > 21
  end

end