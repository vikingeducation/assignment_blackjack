# lib/blackjack.rb
require 'colorize'

module BlackjackHelper
  # attr_reader :deck
  # def initialize(session_deck = nil)
  #   # creates a new deck if no deck provided
  #   if session_deck == nil
  #     d = ((2..10).to_a << ['J','Q','K','A']).flatten!
  #     @deck = d.product(['hearts','clubs','spades','diamonds'])
  #   else
  #     @deck = session_deck
  #   end
  # end

# create deck
 def create_deck(session_deck = nil)
   # creates and shuffles deck
   d = ((2..10).to_a << ['J','Q','K','A']).flatten!
   deck = d.product(['hearts','clubs','spades','diamonds'])
   session["deck"] = deck.shuffle
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

  # suit_handler
  def suit_handler(card)
    # creates a string from the card array
    card[0].to_s + "&" + card[1] + ";"
  end
end
