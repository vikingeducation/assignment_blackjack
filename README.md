# assignment_blackjack
Hit me baby one more time?

[A Blackjack game using the Ruby Sinatra web application framework which uses object oriented programming, cookies, sessions, and JSON from the Viking Code School](http://www.vikingcodeschool.com)

David Meza

Alok Pradhan

# We arrive at index and player starts game [index.erb]
# Primary view kicks off game and shows initial hands: Persist player hand and dealer hand [blackjack.erb]
  # Blackjack page: User can select to hit or stay
    # Hit goes to '/blackjack/hit'
      # If hitting would bust: redirect to '/blackjack/stay'
      # Otherwise stay in 'blackjack/hit' and ask for input again
    # Stay shows results of the game: 'blackjack/stay'
# Layout is primary view
# When we initialize hands we need to take a state [deal_hands.rb]
# Player hand and dealer hand need to be stored in a session
  # Hand is an array with current cards in hand
# Player class: player or dealer - Methods: hit, stay, double, split, bust?, win?, count_points
