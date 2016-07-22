module ViewHelpers

  def show_outcome(outcome)
    tag(:h1, "Player loses") if outcome
  end

end