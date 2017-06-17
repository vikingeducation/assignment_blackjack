# ./helpers/card_helper.rb
module CardHelper

  def start_game
    player_sample = deal
    save_cards(player_sample)
    calculate_score(player_sample[0])

    dealer_sample = load_dealer
    save_dealer_cards(dealer_sample)
    calculate_dealer_score(dealer_sample[0])
  end

  def generate_cards
    number =  [2,3,4,5,6,7,8,9,10,10,10,10, 'A']
    suit = %w{diamonds clubs hearts spades}
    # Simulate the real shuffling of cards
    number.product(suit).shuffle
  end


  def load_deck
     session["deck"] ||= generate_cards
  end

  def deal
    session["deck"] ||= load_deck
     cards_selected = session["deck"].sample
     puts "#{cards_selected} user cards selected"
     session["deck"].delete(cards_selected)
     cards_selected
  end

  def save_cards(cards)
    if session["player_cards"].nil?
      session["player_cards"] = cards
    else
      current = session["player_cards"]
      current << cards
      session["player_cards"] = current
    end
  end

  def game_over?
    # @player.score >= 21 || @dealer.score >= 21 || @combinations.length <= 1
    session["deck"] ||= generate_cards
    deck = session["deck"]

    session["player_score"] >= 21 || 
      session["dealer_score"] >= 17 || deck.length < 1
  end
 
  def calculate_score(card)
    if session["player_score"].nil?
      session["player_score"] = card
    else
      current_score = session["player_score"]
      
      value = check_ace(card, current_score)
      card = value if value > 0

      current_score += card
      session["player_score"] = current_score
    end
  end

  def check_ace(card, score)
    value = 0
    if(card == "A" && (score + 11) > 21)
      value = 1
    elsif(card == "A")
      value = 11
    end
    puts "#{value} - the value of the ace if dealt"
    value
  end

  def load_dealer
    session["deck"] ||= load_deck
     selection = session["deck"].sample
     puts "#{selection} cards selected for dealer"
     session["deck"].delete(selection)
  end

  def save_dealer_cards(cards)
    if session["dealer_cards"].nil?
      session["dealer_cards"] = cards
    else
      current = session["dealer_cards"]
      current << cards
      session["dealer_cards"] = current
    end
  end
 
  def calculate_dealer_score(card)
    if session["dealer_score"].nil?
      session["dealer_score"] = card
    else
      current_score = session["dealer_score"]

      value = check_ace(card, current_score)
      card = value if value > 0

      current_score += card
      session["dealer_score"] = current_score
    end
  end

  def deal_if_play_viable
    if !session["player_score"].nil? && session["player_score"] < 21
      selection = deal
      player_score = session["player_score"] 

      value = check_ace(selection[0], player_score)
      selection[0] = value if value > 0

      if player_score + selection[0] > 21
        return false
      else
        save_cards(selection)
        session["deck"].delete(selection)
        calculate_score(selection[0])
        return true
      end
    else
      return false
    end
  end

  def stay
    while !session["dealer_score"].nil? && session["dealer_score"] < 17
      selection = load_dealer
      dealer_score = session["dealer_score"]

      value = check_ace(selection[0], dealer_score)
      selection[0] = value if value > 0

      if dealer_score + selection[0] > 17
        puts "The dealer can't play anymore due to scores "
        winner = process_winner
        session["winner"] = winner
        return winner
      else
        save_dealer_cards(selection)
        session["deck"].delete(selection)
        calculate_dealer_score(selection[0])
      end
    end
    
      winner = process_winner
      session["winner"] = winner
      return winner
  end

  def process_winner
    dealer_score = session["dealer_score"]
    player_score = session["player_score"] 
   
    if player_score == 21 && dealer_score != 21
      :player
    elsif dealer_score == 21 && dealer_score != 21
      :dealer
    elsif dealer_score > 21 && player_score > 21
      :draw
    elsif player_score > 21
      :dealer
    elsif dealer_score > 21
      :player
    elsif player_score == dealer_score
      :draw
    elsif player_score > dealer_score
      :player
    else
      :dealer
    end
  end

  def quit_message(winner)
    case winner
    when :draw then "It's a draw"
    else 
      "#{winner} wins!"
    end
  end


# Render output
  def load_cards
    session[:player_cards]
  end

  def load_score
    session[:player_score]
  end

  def load_dealer_cards
    session[:dealer_cards]
  end

  def load_dealer_score
    session[:dealer_score]
  end

  def load_winner
    session[:winner]
  end
end