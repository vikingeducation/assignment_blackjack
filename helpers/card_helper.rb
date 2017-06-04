# ./helpers/card_helper.rb
module CardHelper

  # # Save the secret to the session hash
  # # Again, the `self` is implicit for `self.text`
  # def save_cards(secret_text)
  #   session[:secret_text] = secret_text
  # end

    @player_score = 0 
    @combinations = []
    # @current_player = @player
    @game_over = false
    # @player = Player.new
    # @dealer = Dealer.new


  def generate_cards

    @player_score = 0 
    @dealer_score = 0
    @combinations = []
    # @current_player = @player
    @game_over = false
    @player_cards = []
    @dealer_cards = []

    number =  [2,3,4,5,6,7,8,9,10,10,10,10]
    # need to deal with aces separatley
    suit = %w{diamonds clubs hearts spades}
    # Simulate the real shuffling of cards
    @combinations = number.product(suit).shuffle
  
  #    %w{2 3 4 5 6 7 8 9 10 J Q K A}.product(%w{diamonds clubs hearts spades}).shuffle
  end

 
  def deal
     s = @combinations.sample
     save_cards(s)
     puts "#{s} cards selected"
     @combinations.delete(s)
     calculate_score(s[0])
  end

  def save_cards(cards)
    @player_cards << cards
    session[:cards] = @player_cards
  end


  
  # def game_over?
  #   @player.score >= 21 || @dealer.score >= 21 || @combinations.length <= 1
  # end
 
  def calculate_score(n)
    @player_score += n
    session[:player_score] = @player_score
  end


  def deal2
     s = @combinations.sample
     save_cards2(s)
     puts "#{s} cards selected"
     @combinations.delete(s)
     calculate_score2(s[0])
  end

  def save_cards2(cards)
    @dealer_cards << cards
    session[:cards2] = @dealer_cards
  end


  def calculate_score2(n)
    @dealer_score += n
    session[:dealer_score] = @dealer_score
  end


  # def process_input(player_choice)
  #   if(player_choice == "STAY")
  #     @current_player = @dealer
  #   elsif(player_choice == "HIT")
  #     @current_player.deal
  #   end
  # end

  def start_game
    # @player.deal
    # @dealer.deal

    deal
    deal2
  end

  def get_player_choice
    # use session varible - use radio button to get input on the webpage
  end

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
    session[:cards]
  end

  def load_score
    session[:player_score]
  end

  def load_cards2
    session[:cards2]
  end

  def load_score2
    session[:dealer_score]
  end



end