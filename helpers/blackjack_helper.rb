# show current bankroll (blackjack)
# How much do you want to bet?
  ## display feedback - Dont have enough, okay deal hand

# deal hand
  # show players two cards
  # show one dealer card, one "face down"
    # check if player has 21
    # check if dealer has 21
      # if yes - game over, player win or dealer win or draw
        # handle payout
        # update bankroll
        #take to home screen
    # if no - get players move (display partial on bottom of blackjack)
      # stay or hit
    # if stay or bust, dealers turn
    # else get another player move - > request view again

    # dealers turn - if player busted: they lose, show dealers hand
                    # else if dealer is under 17 points - dealer draws a card
                      # check again
                      # if dealer is 17 or above then game over,
                      # check player and dealer hands, higher hand wins unless
                        #bust
