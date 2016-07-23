class PlayerView < View

  def ask_for_hit_or_dd(possible_to_dd)
    input = nil
    until input == 'n' || input == 'y' ||
          (input == 'dd' && possible_to_dd == true)
      output("Can't double down") if input == 'dd'

      output("Would you like to hit (or double down)? dd/y/n")
      input = get_input
    end
    input
  end

  def ask_for_name
    output("What is your name?")
    get_input
  end

  def ask_for_bet_amount(purse_amount)
    output("How much would you like to bet? Purse Amount: #{purse_amount}")
    get_input.to_i
  end
end
