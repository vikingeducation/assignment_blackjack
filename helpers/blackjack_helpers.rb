module BlackjackHelpers
  def save_deck(deck)
    session[:deck] = deck.to_json
  end

  def save_players_cards(players_cards)
    session[:players_cards] = players_cards.to_json
  end

  def save_dealers_cards(dealers_cards)
    session[:dealers_cards] = dealers_cards.to_json
  end

  def load_deck
    JSON.parse(session[:deck])
  end

  def load_players_cards
    JSON.parse(session[:players_cards])
  end

  def load_dealers_cards
    JSON.parse(session[:dealers_cards])
  end

  def get_player_total
    total = [0,0]
    ace = false
    JSON.parse(session[:players_cards]).each do |card|
      ace = true if card[0].upcase == "A"
      if card[0].to_i > 0
        total[0] += card[0].to_i
        total[1] += card[0].to_i
      elsif card[0].upcase == 'A'
        # Two aces are an issue
        total[0] = total[0]+1
        total[1] = total[0]+10
      else
        total[0] += 10
        total[1] += 10
      end
    end
    total = [total[0]] if total[1] > 21 || ace == false
    total
  end

  def get_dealer_total
    total = [0,0]
    ace = false
    JSON.parse(session[:dealers_cards]).each do |card|
      ace = true if card[0].upcase == "A"
      if card[0].to_i > 0
        total[0] += card[0].to_i
        total[1] += card[0].to_i
      elsif card[0].upcase == 'A'
        # Two aces are an issue
        total[0] = total[0]+1
        total[1] = total[0]+10
      else
        total[0] += 10
        total[1] += 10
      end
    end
    total = [total[0]] if total[1] > 21 || ace == false
    total
  end
end