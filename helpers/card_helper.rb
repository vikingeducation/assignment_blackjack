# ./helpers/card_helper.rb
module CardHelper

  # Save the secret to the session hash
  # Again, the `self` is implicit for `self.text`
  def save_cards(secret_text)
    session[:secret_text] = secret_text
  end

  def initialize
    @player_score = 0 
    @combinations = []
    @current_player = @player
    @game_over = false
    @player = Player.new
    @dealer = Dealer.new
  end


  def generate_cards
    number =  [2,3,4,5,6,7,8,9,10,10,10,10]
    # need to deal with aces separatley
    suit = %w{diamonds clubs hearts spades}
    @combinations = number.product(suit)
  
  #    %w{2 3 4 5 6 7 8 9 10 J Q K A}.product(%w{diamonds clubs hearts spades}).shuffle
  end
 
  def deal
     2.times do
       s = @combinations.sample
       @combinations.delete(s)
       calculate_score(s[0])
     end
  end

  def game_over?
    @player.score >= 21 || @dealer.score >= 21 || @combinations.length <= 1
  end
 
  def calculate_score(n)
    @player_score += n
  end

  def process_input(player_choice)
    if(player_choice == "STAY")
      @current_player = @dealer
    elsif(player_choice == "HIT")
      @current_player.deal
    end
  end

  def start_game
    @player.deal
    @dealer.deal
  end

  def get_player_choice
    # use session varible - use radio button to get input on the webpage
  end

  def play
    start_game
    while !game_over?
      user_choice = @current_player.get_player_choice
      process_input(user_choice)
      
    end
    quit_msg
  end


  IN DEALER method - the user input should always be HIT of has 17 or more

  def quit_msg
    if(player.score >= 21 || @player.score <)
  end

  # Load the secret from the session
  def load_cards
    session[:secret_text]
  end
end