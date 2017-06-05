# ./helpers/card_helper.rb
module CardHelper

  # # Save the secret to the session hash
  # # Again, the `self` is implicit for `self.text`
  # def save_cards(secret_text)
  #   session[:secret_text] = secret_text
  # end

    # @player_score = 0 
    # @combinations = []
    # # @current_player = @player
    # @game_over = false
    # @player = Player.new
    # @dealer = Dealer.new

  def start_game
    # @player.deal
    # @dealer.deal
    deal
    load_dealer
  end

  def load_deck
     session["deck"] ||= generate_cards
  end

  def generate_cards
    # @player_score = 0 
    # @dealer_score = 0
    # @combinations = []
    # # @current_player = @player
    # @game_over = false
    # @player_cards = []
    # @dealer_cards = []

    number =  [2,3,4,5,6,7,8,9,10,10,10,10]
    # need to deal with aces separatley
    suit = %w{diamonds clubs hearts spades}
    # Simulate the real shuffling of cards
    number.product(suit).shuffle
  end

 
  def deal
    session["deck"] ||= load_deck
     # s = @combinations.sample
     s = session["deck"].sample
     save_cards(s)
     # puts "#{s} cards selected"
     # @combinations.delete(s)
     session["deck"].delete(s)
     # session["deck"] = nil if session['deck'].empty?
     calculate_score(s[0])
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
 
  def calculate_score(n)
    if session["player_score"].nil?
      session["player_score"] = n
    else
      current = session["player_score"]
      current += n
      session["player_score"] = current
    end

    # @player_score += n
    # session[:player_score] = @player_score
  end


  def load_dealer
    session["deck"] ||= load_deck
     # s = @combinations.sample
     s = session["deck"].sample
     save_dealer_cards(s)
     # puts "#{s} cards selected"
     # @combinations.delete(s)
     session["deck"].delete(s)
     # session["deck"] = nil if session['deck'].empty?
     calculate_dealer_score(s[0])
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
 
  def calculate_dealer_score(n)
    if session["dealer_score"].nil?
      session["dealer_score"] = n
    else
      current = session["dealer_score"]
      current += n
      session["dealer_score"] = current
    end
  end

  def deal_if_play_viable
    if !session["player_score"].nil? && session["player_score"] < 21
      session["deck"] ||= load_deck
      s = session["deck"].sample

      if session["player_score"]+ s[0] > 21
        return "not viable"
      else
        save_cards(s)
        session["deck"].delete(s)
        calculate_score(s[0])
      end
    end
    # @player.score >= 21 || @dealer.score >= 21 || @combinations.length <= 1
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


  # IN DEALER method - the user input should always be HIT of has 17 or more

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