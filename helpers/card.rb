# helpers/card.rb

Card = Struct.new(:suit, :rank) do

  def value
    case rank
    when ("1".."10")
      rank.to_i
    when "Ace"
      11
    else
      10
    end
  end

end

