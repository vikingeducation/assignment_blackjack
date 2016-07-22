

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

  def save_session(args* deck, player_hand, dealer_hand, bet)
    args.each do |key|
      session["#{key}"] = key.to_json

    session["deck"] = deck.to_json
    session["player_hand"] = player_hand.to_json
    session["dealer_hand"] = dealer_hand.to_json
    session["bet"] = bet
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



end
