module ViewHelpers

  def show_outcome(outcome)
    tag(:h1, "Player loses", :class => "bg-danger") if outcome
  end

end