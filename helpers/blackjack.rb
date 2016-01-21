


class Blackjack

  @@SHOE = %w[ A 2 3 4 5 6 7 8 9 10 J Q K]*4

  attr_reader :dealers_hand, :players_hand

  def initialize(shoe=nil)
    create_shoe if shoe.nil? 
  end

  def create_shoe
    10.times { @@SHOE.shuffle! }
  end

  def deal_card
    @@SHOE.pop
  end

  def start_game
    @dealers_hand = []
    @players_hand = []
    2.times do
      @layers_hand << deal_card
      @dealers_hand << deal_card
    end
    @dealers_hand, @players_hand
  end

  def 
  end


end