require './blackjack.rb'
module BlackjackHelpers
include Blackjack

  # When the initial cards are dealt, check for blackjacks.
  def check_winner(d_hand,p_hand)
    if blackjack?(d_hand) && blackjack?(p_hand)
      tie
    elsif blackjack?(d_hand) && !blackjack?(p_hand)
      game_over
    elsif blackjack?(p_hand)
      blackjack
    end

  end

  # Ends the current hand, adds to the player's money based on the result.
  # Starts up a game with the second hand if the player has split.

  def award_player(multiplier)
    if session['doubled']
        session['money'] += session['bet'] * multiplier * 2
        session['doubled'] = nil
    else
      session['money'] += session['bet'] * multiplier
    end
  end

  def generate_new_hands
    new_hand = session['split_hands'].pop
    new_d_hand = []
    deal(new_hand, new_d_hand)
    deal(new_hand + new_d_hand, new_d_hand)
    return new_hand, new_d_hand
  end

  def end_game(result, multiplier)
    award_player(multiplier)
    if session['split_hands'] && session['split_hands'].any?
      session['p_hand'], session['d_hand'] = generate_new_hands

      flash[:notice] = result
      redirect '/blackjack'
    else
      session['ingame'] = false
      session['bet'] = nil

      flash[:notice] = result
      redirect "/blackjack/result/"
    end
  end

  def game_over
    end_game("You lose...", 0)
  end

  def win
    end_game("You Win!", 2)
  end

  def blackjack
    end_game("Blackjack!", 2.5)
  end

  def tie
    end_game("You Pushed!", 1)
  end

  def calculate_result(d_hand, p_hand)
    game_over if bust?(p_hand)
    win if bust?(d_hand)
    win if value_hand(p_hand) > value_hand(d_hand)
    tie if value_hand(p_hand) == value_hand(d_hand)
    game_over
  end
end