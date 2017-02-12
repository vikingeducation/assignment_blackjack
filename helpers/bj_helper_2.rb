
module BJHelper

  class Player

    attr_accessor :bankroll

    def initialize(session_hand, bankroll) #make it to_json in app
      session_hand == nil ? @session_hand = nil : @session_hand = JSON.parse(session_hand,:quirks_mode => true)
      bankroll.nil? ? @bankroll = 1000 : @bankroll = JSON.parse(bankroll,:quirks_mode => true)
      @decks = Deck.new
    end

    def load_player_hand
      @session_hand ? @session_hand : [@decks.deal_hand, @decks.deal_hand]
    end

  end

  class Dealer

    def initialize(session_hand) #make it to_json in app
      session_hand == nil ? @session_hand = nil : @session_hand = JSON.parse(session_hand,:quirks_mode => true)
      @decks = Deck.new
    end

    def load_dealer_hand
      @session_hand ? @session_hand : [@decks.deal_hand, @decks.deal_hand]
    end

  end

  class Deck

    def initialize #make it to_json in app
      @five_decks = create_decks # if @session_hash.decks == nil || @session_hash.decks  == []
    end

    def decks_builder
      [2,3,4,5,6,7,8,9,10, "J", "Q", "K", "A"].product(["Diamonds", "Hearts", "Clubs", "Spades"])
    end

    def create_decks
      the_deck = []
      4.times { |i| the_deck += decks_builder }
      the_deck.shuffle
    end

    def deal_hand
      @five_decks.pop
    end

    def checking_points(current_hand)
      total = 0
      as_value = 0
      current_hand.each do |arr|
        if %w{J K Q}.include? arr[0]
          total += 10
        elsif "A" == arr[0]
          total += 1
          as_value += 10
        else
          total += arr[0]
        end
      end
      puts "DBG: total = #{total.inspect}"
      puts "DBG: match_ases_for_best_total(total, as_value) = #{match_ases_for_best_total(total, as_value).inspect}"
      match_ases_for_best_total(total, as_value)
    end

    def match_ases_for_best_total(total, as_value)
      if total <= 11
        as_value != 0 ? total += 10 : total
      else
        total
      end
    end

    def check_who_won(player_hand, dealer_hand)
      if checking_points(player_hand) <= 21 && checking_points(dealer_hand) <= 21
        checking_points(player_hand) <=> checking_points(dealer_hand)
      elsif checking_points(player_hand) > 21
        -1
      else
         1
      end
    end

  end

end