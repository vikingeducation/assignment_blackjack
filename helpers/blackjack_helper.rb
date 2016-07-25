module BlackjackHelper

CONVERSIONS = {"11" => "J", "12" => "Q", "13" => "K", "1" => "A"}

def self.convert_hand(hand)
  cards = hand.map do |card|
      if CONVERSIONS[card.to_s]
        CONVERSIONS[card.to_s]
      else
        card
      end
  end
end

end

# A 6  total = 7 or 17
# A 3 K total = 14 

#
#
#