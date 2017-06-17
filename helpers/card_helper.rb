# ./helpers/card_helper.rb
module CardHelper

  def start_game
    # @player.deal
    # @dealer.deal
    player_sample = deal
    save_cards(player_sample)
    calculate_score(player_sample[0])

    
    dealer_sample = load_dealer
    save_dealer_cards(dealer_sample)
    calculate_dealer_score(dealer_sample[0])
  end

  def load_deck
     session["deck"] ||= generate_cards
  end

  def generate_cards
    number =  [2,3,4,5,6,7,8,9,10,10,10,10, 'A']
    # need to deal with aces separatley
    suit = %w{diamonds clubs hearts spades}
    # Simulate the real shuffling of cards
    number.product(suit).shuffle
  end

 
  def deal
    session["deck"] ||= load_deck
     # s = @combinations.sample
     cards_selected = session["deck"].sample
     # save_cards(s)
     puts "#{cards_selected} cards selected"
     # @combinations.delete(s)
     session["deck"].delete(cards_selected)
     # session["deck"] = nil if session['deck'].empty?
     # calculate_score(s[0])
     cards_selected
  end

  def save_cards(cards)
    # @player_cards << cards
    # session[:player_cards] ||= cards

    if session["player_cards"].nil?
      session["player_cards"] = cards
    else
      current = session["player_cards"]
      current << cards
      session["player_cards"] = current
    end
  end

  # def game_over?
  #   @player.score >= 21 || @dealer.score >= 21 || @combinations.length <= 1
  # end
 
  def calculate_score(card)
    if session["player_score"].nil?
      session["player_score"] = card
    else
      current_score = session["player_score"]
      
      value = check_ace(card[0], current_score)
      card = value if value > 0

      current_score += card
      session["player_score"] = current_score
    end

    # @player_score += card
    # session[:player_score] = @player_score
  end

  def check_ace(card, score)
    value = 0
    if(card == "A" && (score + 11) > 21)
      value = 1
    elsif(card == "A")
      value = 11
    end
    puts "#{value} - an ace was dealt"
    value
  end


  def load_dealer
    session["deck"] ||= load_deck
     # s = @combinations.sample
     s = session["deck"].sample
     # save_dealer_cards(s)
     puts "#{s} cards selected for dealer"
     # @combinations.delete(s)
     session["deck"].delete(s)
     # session["deck"] = nil if session['deck'].empty?
     # calculate_dealer_score(s[0])
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

      value = check_ace(card[0], current_score)
      card = value if value > 0

      current_score += card
      session["dealer_score"] = current_score
    end
  end

  def deal_if_play_viable
    if !session["player_score"].nil? && session["player_score"] < 21
      # session["deck"] ||= load_deck
      # s = session["deck"].sample
      selection = deal

      if session["player_score"] + selection[0] > 21
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
    # @player.score >= 21 || @dealer.score >= 21 || @combinations.length <= 1
  end

  def stay
    while !session["dealer_score"].nil? && session["dealer_score"] < 17
      # session["deck"] ||= load_deck
      # s = session["deck"].sample
      selection = deal

      if session["dealer_score"]+ selection[0] > 17
        break
      else
        save_dealer_cards(selection)
        session["deck"].delete(s)
        calculate_dealer_score(selection[0])
        return true
      end
    end
  end

  # def process_input(player_choice)
  #   if(player_choice == "STAY")
  #     @current_player = @dealer
  #   elsif(player_choice == "HIT")
  #     @current_player.deal
  #   end
  # end


  # def play
  #   start_game
  #   while !game_over?
  #     user_choice = @current_player.get_player_choice
  #     process_input(user_choice)
  #   end
  #   quit_msg
  # end


  # def quit_msg
  #   if(@current_player.score >= 21 || @current_player.score <)
  # end

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
end