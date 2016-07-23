class GameView < View

  def print_resetting_hands
    print 'resetting hands'
    3.times do
      sleep 1
      print '.'
    end
    output
  end

  def print_dealing_message
    print 'dealing'
    3.times do
      sleep 1
      print '.'
    end
    output
  end

  def print_game_results(purse_amount)
    if purse_amount > 0
      output("You leave the game with #{purse_amount} left over.")
    else
      output("You went broke...")
    end
  end

  def print_player_hand(player)
    if player.is_a?(HumanPlayer)
      output("Your hand:")
      render_cards(player.cards_in_hand)
    else
      output("The Dealer's Cards:")
      render_cards(player.cards_in_hand)
    end
  end

  def print_dealt_cards(player_cards, dealer_cards)
    output("Your cards:")
    render_cards(player_cards)
    output("The Dealer's Cards:")
    render_cards(dealer_cards)
    output
  end

  def print_player_win(name = nil)
    if name
      output("Congratulations #{name} you win this round!")
    else
      output("Congrats player you win this round!")
    end
  end

  def print_blackjack
    output("WINNER WINNER CHICKEN DINNER YOU GOT BLACKJACK")
  end

  def print_tie
    output("It was a draw.")
  end

  def print_busted
    output("BUSTED")
  end

  def print_score_results(player_score, dealer_score)
    output("Player's Score: #{player_score}")
    output("Dealer's Score: #{dealer_score}")
  end

  def print_player_loss
    output("The dealer won this round...")
  end

  def render_cards(cards)
    return_string = ''
    cards = cards.map { |card| convert_card_to_render_string(card).split("\n") }
    card_render_string_length.times do
      cards.each { |card| return_string << (card.shift + "   ") }
      return_string << "\n"
    end
    output(return_string)
  end

  private

  def card_render_string_length
    7
  end

  def convert_card_to_render_string(card)
    if card.face_down?
      face_down_card
    else
      "----------\n" +
        "|#{card.rank_symbol}#{' ' * (7 - card.rank_symbol.length)}#{card.suit_symbol}|\n" +
        "|        |\n" +
        "|        |\n" +
        "|        |\n" +
        "|#{card.suit_symbol}#{' ' * (7 - card.rank_symbol.length)}#{card.rank_symbol}|\n" +
        "----------"
    end
  end

  def face_down_card
    "----------\n" +
    "| **  ** |\n" +
    "| **  ** |\n" +
    "|        |\n" +
    "|\\      /|\n" +
    "| ****** |\n" +
    "----------"
  end
end
