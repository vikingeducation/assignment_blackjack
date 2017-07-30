# lib/blackjack.rb
require 'colorize'

module BlackjackHelper
# create deck
 def create_deck(session_deck = nil)
   # creates and shuffles deck
   d = ((2..10).to_a << ['J','Q','K','A']).flatten!
   deck = d.product(['hearts','clubs','spades','diams'])
  #  deck = d.product(['#9825', 'clubs', 'spades', '#9826'])
   session["deck"] = deck.shuffle
 end

 def deal
   unless session["p_hand"]
     session["p_hand"] = Array.new
     session["c_hand"] = Array.new
     2.times {hit}
   end
 end

 def load_deck(session_deck = nil)
   if session_deck
     session["deck"] = session_deck
   else
     create_deck
   end
    session["deck"]
 end

# draw_card
  def draw_card
    session["deck"].shift
  end

  #hit
  def hit
    session["p_hand"] << draw_card
    session["c_hand"] << draw_card
  end

  # tallies score of a hand
  def score(hand)
    #iterates through each item in the hand array
    sum = 0
    hand.each do |num|
      if num.is_a?(Integer)
        sum += num
      end
    end
    sum
  end

  # suit_handler
  def suit_handler(card)
    # creates a string from the card array
    card[0].to_s + "&" + card[1] + ";"
  end

  def score(hand)
    #iterates through each item in the hand array
    sum = 0
   #  has_ace = has_ace?(hand)
   aces = 0
    hand.each do |num|
      val = num[0]
      if val.is_a?(Integer)
        sum += val
      elsif val == 'A'
        aces += 1
        sum += 11
      else
        sum += 10
      end
    end
    # subtracts value of aces if greater than 21
    if sum > 21
      while aces > 0
        sum -= 10
        aces -= 1
      end
    end
   sum
  end

 # has_ace?
  # def has_ace?(hand)
  #   # determines if the hand contains an ace
  #   hand.each do |num|
  #     if num.include? 'A'
  #       return true
  #       break
  #     end
  #   end
  #   false
  # end

   def stay
     until game_over
        session["c_hand"] << draw_card
      end
   end

   def game_over
     p_score = score(session["p_hand"])
     c_score = score(session["c_hand"])
     if c_score == 21 || c_score.between?(p_score, 21)
       comp_wins
       true
     elsif c_score > 21
       player_wins
       true
     else
       false
     end
   end

   def bust?(hand)
     score(hand) > 21
   end

   def player_wins
     session[:outcome] = "You win!"
     # pot goes to player
   end

   def comp_wins
     session[:outcome] = "The dealer wins!"
     # pot goes to dealer
   end

   def new_game
     session.clear
   end

end



######
wtf_hand = [[9, "diams"], [7, "diams"]]
sample_hand = [[7, "spades"], [10, "diams"], ["J", "hearts"]]
hand_w_ace = [[4, "spades"], [4, "diams"], [3, "spades"], ["A", "diams"]]
winning_hand = [["A", "spades"], [10, "diams"]]
improb_hand = [["A", "spades"],["A", "spades"],["A", "spades"],["A", "spades"]]
 # tallies score of a hand

 def score(hand)
   #iterates through each item in the hand array
   sum = 0
  #  has_ace = has_ace?(hand)
  aces = 0
   hand.each do |num|
     val = num[0]
     if val.is_a?(Integer)
       sum += val
     elsif val == 'A'
       aces += 1
       sum += 11
     else
       sum += 10
     end
   end
   # subtracts value of aces if greater than 21
   if sum > 21
     while aces > 0
       sum -= 10
       aces -= 1
     end
   end
  sum
 end


# # has_ace?
#  def has_ace?(hand)
#    # determines if the hand contains an ace
#    hand.each do |num|
#      if num.include? 'A'
#        return true
#        break
#      end
#    end
#    false
#  end
 puts score(wtf_hand)
 puts score(winning_hand)
 puts score(hand_w_ace)
 puts score(improb_hand)
