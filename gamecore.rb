#Game will validate winner, give new cards, heandle calculate cards face val

class Game

  def initialize(dealercards, playercards)
    @dealercards = dealercards
    @playercards = playercards
    @cards=[1,2,3,4,5,6,7,8,9,10,10,10,10]
    # @set=[@cards[rand(0..@cards.length-1)],@cards[rand(0..@cards.length-1)]]
  end


  def add_card(cards)
    cards << @cards[rand(0..@cards.length-1)]
  end

  def hit
    add_card(@playercards)
  end

  def stand
    until game_over?
       add_card(@dealercards)
    end
  end

  def deal
    2.times do 
      add_card(@playercards)
      add_card(@dealercards)
    end
  end

  def face_value(cards)
    num_aces = cards.count {|item| item == 1} 
    # p num_aces
    total = cards.inject(0){|sum,item| sum+item}
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


  def winner(player, computer)
    if player.result > computer.result
      puts "You won! You got #{player.result}."
    else
      puts "Computer won! Computer  got #{computer.result}"
    end
  end

  def game_over?
    face_value(@dealercards) > 21 || face_value(@playercards) > 21 
  end

end


