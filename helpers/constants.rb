module Constants
  RANKS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  SUITS = %w(clubs diamonds hearts spades)
  DECK = RANKS.product(SUITS)
end