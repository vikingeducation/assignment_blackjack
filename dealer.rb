class Dealer

  attr_reader :hand

  def initialize(hand=[], deck, player)
    @deck = deck
    @hand = hand
    @player = player
  end

  # Initial Deal
  def deal
    @player.hand << @deck.pop
    @hand << @deck.pop
    @player.hand << @deck.pop
    @hand << @deck.pop
  end

  def deal_card_to_player
    @player.hand << @deck.pop
  end

  # Getting the final total after dealer has finished his turn.
  def return_dealers_final_total(player_busted)
    # If the player has busted, dealer doesn't draw any more cards
    if player_busted
      dealer_total = get_dealer_current_total
    else
      dealer_total = get_dealer_current_total
      until dealer_total >= 17
        deal_card_to_dealer
        dealer_total = get_dealer_current_total
      end
    end
    dealer_total
  end

  private

  def deal_card_to_dealer
    @hand << @deck.pop
  end

  # Returns an array.
  # In case there is an ACE
  def get_dealer_current_total
    # The first number is the total when counting aces as 1.
    total = [0,0]
    # Going through each card in dealer's hand
    @hand.each do |card|
      # if the card is a number card then add that number to both numbers in the array.
      if card[0].to_i > 0
        total[0] += card[0].to_i
        total[1] += card[0].to_i
      # If the current card is an ace, add 1 to the first number and 10 to the second number.
      # Has to be done this way in case there's multiple aces.
      # If there are multiple aces, only one can count as a 11!
      elsif card[0].upcase == 'A'
        total[0] += 1
        total[1] = total[0]+10
      # All other cards (suited but not ace) add ten to both
      else
        total[0] += 10
        total[1] += 10
      end
    end
    # If the dealer has an ace and counting that ace as an
    return total.min if total[1] > 21
    total.max
  end
end