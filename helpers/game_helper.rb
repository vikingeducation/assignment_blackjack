module GameHelper

  def save_game_state(player, hand = nil)
    session[:player] = player
    session[:hand] = hand
  end


  def declare_winner(player_total, dealer_total)
    winner = ""

    winner = "Dealer wins!" if busted?(player_total)
    winner = "Player wins!" if busted?(dealer_total)

    if winner == ""
      winner = case player_total <=> dealer_total
      when -1
        "Dealer wins!"
      when 1
        "Player wins!"
      when 0
        "Push!"
      end
    end

    winner

  end


  def busted?(total)
    total > 21
  end

end