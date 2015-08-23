module BlackJackJudge
=begin
  def save(player, ai, money, status)
      session[:player] = player
      session[:ai] = player
      session[:money] = money
      session[:status] = status
  end  #no use function
=end

  def check(player)
    sum = 0
    player.each do |number|
      sum += number.to_i if [2,3,4,5,6,7,8,9,10].include?(number)
      sum += 10 if ["J", "Q", "K"].include?(number)
    end
    player.each do |number|
      if number == "A"
        sum += 11 if sum + 11 <= 21
        sum += 1 if sum + 11 > 21
      end
    end
    return sum
  end

  def wincheck(ai, player)
    return "win" if ai > 21
    return "win" if ai < player
    return "loss" if ai > player
    return "draw" if player == ai
  end

  def bustcheck(array)
    if check(array) > 21
      return "bust"
    else
      return ""
    end
  end

end