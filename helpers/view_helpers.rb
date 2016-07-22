module ViewHelpers

  def show_outcome(outcome)
    tag(:h1, "Player loses") if outcome[0]
    tag(:h1, "Dealer loses") if outcome[1]
  end

end