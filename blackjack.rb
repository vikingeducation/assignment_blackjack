# The objective of the game is to beat the dealer in one of the following ways:
#
# - Get 21 points on the player's first two cards (called a "blackjack" or
# "natural"), without a dealer blackjack;
# - Reach a final score higher than the dealer without exceeding 21; or
# - Let the dealer draw additional cards until his or her hand exceeds 21.

# Rules
# - The players are dealt two cards and add together the value of their cards.
# - Face cards (kings, queens, and jacks) are counted as ten points
# - A player and the dealer can count an ace as 1 point or 11 points
# - All other cards are counted as the numeric value shown on the card
# - The playerwins by having a score of 21 or by having the higher score
# that is less than 21
# - Scoring higher than 21 results in a loss

class Blackjack
  attr_accessor :deck, :p1, :p2

  SUITS = ["clubs", "diamonds", "hearts", "spades"]
  RANKS = (2..10).to_a + ["ace", "jack", "queen", "king"]

  def initialize(cards1=[], cards2=[], deck=nil)
    @deck = deck || make_deck.flatten!.shuffle
    @p1 = make_player(cards1)
    @p2 = make_player(cards2)
  end

  def make_card(suit, rank)
    {suit: suit, rank: rank}
  end

  def make_player(cards)
    {cards: cards}
  end

  def make_deck
    SUITS.map do |s|
      RANKS.map do |r|
        make_card(s, r)
      end
    end
  end

  def deal_card!(p)
    card = deck.pop
    p[:cards].push(card)
  end

  def deal_hands!(n=1)
    [p1, p2].each do |p|
      n.times do |i|
        deal_card!(p)
      end
    end
  end

  def get_score(cards)
    cards.map do |card|
      rank = card[:rank]
      if rank.is_a? String
        rank == "ace" ? (cards.count > 2 ? 1 : 11) : 10
      else
        rank
      end
    end.sum
  end

  def result
    score1, score2 = get_score(p1[:cards]), get_score(p2[:cards])
    return "Draw" if score1 > 21 && score2 > 21
    if score1 > score2
      return "You Lose" if score1 > 21
      "You win!"
    elsif score2 > score1
      return "You win!" if score2 > 21
      "You lose!"
    else
      "Draw!"
    end
  end

end
