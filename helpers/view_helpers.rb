module ViewHelpers

  def show_outcome(outcome)
    outcome == :tie ? 'Tie' : outcome
  end

  def show_dealer_hand(dealer_hand,outcome)
    outcome ? dealer_hand : dealer_hand[1..-1]
  end

end