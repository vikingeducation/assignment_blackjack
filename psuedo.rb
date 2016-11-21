  # if session[:player_hand]
    # add up all hands and store it in a 'round' array
    # round.each
      # if the player's hand is 21
        # player wins
      # if players hand is > 21
        # player loses
      # else
        # continue playing

    # while player_hand < 21
      # hit
        # push new card to player's hand
      # stay
        # do nothing

    # check hands
      # 21 - player's hand / 21 - d


def play
  deal
    player_hand = 11, 11
    dealer_hand = 11, 11
  current_turn = player
  unless win_condition
    player can hit
    player can stay
      current_turn = dealer

    dealer hit
    dealer stay
  end
end

def win_condition
end
