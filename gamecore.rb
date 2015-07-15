#Game will validate winner, give new cards, heandle calculate cards face val

#Card = Struct.new(:value, :suit, :name)

class Game
  attr_accessor :dealercards, :playercards
  def initialize(dealercards, playercards)
    @dealercards = dealercards
    @playercards = playercards
    @cards=[1,2,3,4,5,6,7,8,9,10,10,10,10]
  end


  def add_card(cards)
    cards << @cards[rand(0..@cards.length-1)]
  end

  def hit
    add_card(@playercards)
  end

  def stand
    until value(@dealercards)>16
       add_card(@dealercards)
    end
  end

  def deal
    2.times do 
      add_card(@playercards)
      add_card(@dealercards)
    end
  end

  def value(cards)
    num_aces = cards.count {|item| item == 1} 
    # p num_aces
    total = cards.inject(0){|sum,item| sum+item }
    # puts total
    # aces.inject(total) {|sum, item| sum+10 if sum+10<21}
    num_aces.times do
      break if total + 10 > 21
      total += 10
    end
    total
  end

  def check
    if result == 21 
      puts "#{@name} won! #{@name} got 21."
      exit
    elsif 
      result > 21
      puts "#{@name} lose! #{@name} got #{result}."
      exit
    end
  end


  def busted?(cards)
    value(cards) > 21
  end

  def game_over(choise)
    return "Winner!" if value(@playercards) == 21
    return "Looser!" if value(@dealercards) == 21

    if choise == "Stand"
      return "Tie!" if value(@dealercards)==value(@playercards)
      if value(@dealercards)<value(@playercards) || busted?(@dealercards)
        return "Winner!" 
      else
        return "Looser!"
      end
    elsif choise == "Hit"
      return "Winner!" if busted?(@dealercards)
      return "Looser!" if busted?(@playercards)  
    end

  return false
  end
end

g=Game.new([],[])
puts g.value([1,2,3])


