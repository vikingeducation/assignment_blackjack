class Deck


  def initialize(shoe=nil)
    @shoe = %w[ A 2 3 4 5 6 7 8 9 10 J Q K]*4
    create_shoe if shoe.nil? 
  end

  def create_shoe
    10.times { @shoe.shuffle! }
  end

  def deal_card
    @shoe.pop
  end


end