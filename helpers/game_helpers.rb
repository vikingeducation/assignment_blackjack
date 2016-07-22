

module GameHelpers

VALUES = {
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 10,
    "Q" => 10,
    "K" => 10,
    "A" => 11
  }

  def check_hand(hand)
    sum = 0
    hand.each do |card|
      card.length == 3 ? sum += 10 : sum += VALUES[card[0]]
    end
    sum = check_for_aces(sum, hand)
  end

  def check_for_aces(sum, hand)
    if sum > 21
      card_count = 0
      while sum > 21 && card_count < hand.length
        sum -= 10 if hand[card_count][0] == "A"
        card_count += 1
      end
    end
    sum
  end

  def compare_values(player_hand, dealer_hand)
    return "Dealer busts! You win!" if check_hand(dealer_hand) > 21
    return "It's a tie. You get your money back" if check_hand(player_hand) == check_hand(dealer_hand)
    check_hand(player_hand) > check_hand(dealer_hand) ? "You win!" : "You lose, sorry"
  end

  def get_message(player_hand, dealer_hand)
    message = "What's your next move?"
    if session["stayed"]
      message = compare_values(player_hand, dealer_hand)
    else
      if check_hand(dealer_hand) == 21
        if check_hand(player_hand) == 21
          message = "It's a tie!"
        else
          message = "You lose without even playing."
        end
      elsif check_hand(player_hand) == 21
        message = "Congratulations, you win without trying!"
      elsif check_hand(player_hand) > 21
        message = "Bust!"
      end
    end
    message
  end

  def save_session( options = {} )
    options.each do |key, value|
      session[key] = value
    end
  end

  def update_bankroll(message)
    bankroll = request.cookies["bankroll"].to_i
    bet = session["bet"].to_i
    losing_messages = ["You lose without even playing.", "You lose, sorry", "Bust!"]
    winning_messages = ["Dealer busts! You win!", "You win!"]
    if losing_messages.include?(message)
      bankroll -= bet
    elsif winning_messages.include?(message)
      bankroll += bet
    elsif message == "Congratulations, you win without trying!"
      bankroll += (bet * 1.5)
    end
    response.set_cookie("bankroll", bankroll)
    bankroll
  end

  def hit_player
    deck = JSON.parse(session["deck"])
    player_hand = JSON.parse(session["player_hand"])
    player_hand << deck.pop

    session["deck"] = deck.to_json
    session["player_hand"] = player_hand.to_json
  end

  def get_redirect(player_hand)
    if check_hand(player_hand) > 21
      redirect to("/blackjack")
    else
      redirect to("/blackjack/stay")
    end
  end

  PICTURES = {
    "10C" => "10_of_clubs.png",
    "10D" => "10_of_diamonds.png",
    "10H" => "10_of_hearts.png",
    "10S" => "10_of_spades.png",
    "2C" => "2_of_clubs.png",
    "2D" => "2_of_diamonds.png",
    "2H" => "2_of_hearts.png",
    "2S" => "2_of_spades.png",
    "3C" => "3_of_clubs.png",
    "3D" => "3_of_diamonds.png",
    "3H" => "3_of_hearts.png",
    "3S" => "3_of_spades.png",
    "4C" => "4_of_clubs.png",
    "4D" => "4_of_diamonds.png",
    "4H" => "4_of_hearts.png",
    "4S" => "4_of_spades.png",
    "5C" => "5_of_clubs.png",
    "5D" => "5_of_diamonds.png",
    "5H" => "5_of_hearts.png",
    "5S" => "5_of_spades.png",
    "6C" => "6_of_clubs.png",
    "6D" => "6_of_diamonds.png",
    "6H" => "6_of_hearts.png",
    "6S" => "6_of_spades.png",
    "7C" => "7_of_clubs.png",
    "7D" => "7_of_diamonds.png",
    "7H" => "7_of_hearts.png",
    "7S" => "7_of_spades.png",
    "8C" => "8_of_clubs.png",
    "8D" => "8_of_diamonds.png",
    "8H" => "8_of_hearts.png",
    "8S" => "8_of_spades.png",
    "9C" => "9_of_clubs.png",
    "9D" => "9_of_diamonds.png",
    "9H" => "9_of_hearts.png",
    "9S" => "9_of_spades.png",
    "AC" => "ace_of_clubs.png",
    "AD" => "ace_of_diamonds.png",
    "AH" => "ace_of_hearts.png",
    "AS" => "ace_of_spades.png",
    "JH" => "jack_of_clubs.png",
    "JS" => "jack_of_diamonds.png",
    "JC" => "jack_of_hearts.png",
    "JD" => "jack_of_spades.png",
    "KH" => "king_of_clubs.png",
    "KS" => "king_of_diamonds.png",
    "KC" => "king_of_hearts.png",
    "KD" => "king_of_spades.png",
    "QH" => "queen_of_clubs.png",
    "QS" => "queen_of_diamonds.png",
    "QC" => "queen_of_hearts.png",
    "QD" => "queen_of_spades.png"
  }


end
