# ./helpers/card_helper.rb
module CardHelper

  # Save the secret to the session hash
  # Again, the `self` is implicit for `self.text`
  def save_cards(secret_text)
    session[:secret_text] = secret_text
  end

  # def generate_cards
  #   cards =  [2,2,2,2,3,4,5,6,7,8,9,10,10,10,10]
  #   @combinations = cards.product(cards)
  
  #    %w{2 3 4 5 6 7 8 9 10 J Q K A}.product(%w{diamonds clubs hearts spades}).shuffle
  #  end
 
  #  def deal
  #    2.times do
  #      s = @cards.sample
       
  #      @combinations.delete(s)
  #      s = @combinations.sample

  #      @cards.delete(s)
  #    end
  #  end
 


  # Load the secret from the session
  def load_cards
    session[:secret_text]
  end
end