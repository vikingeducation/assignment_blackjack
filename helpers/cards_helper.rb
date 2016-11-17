module CardsHelper

  POINTS = { "10" => 'k', 'q', 'j' }
  SUITS = ['clubs', 'diamonds', 'spades', 'hearts']

  deck = {
            '2' => SUITS.dup, '3' => SUITS.dup, '4' => SUITS.dup,
            '5' => SUITS.dup, '6' => SUITS.dup, '7' => SUITS.dup,
            '8' => SUITS.dup, '9' => SUITS.dup, '10' => SUITS.dup,
            'J' => SUITS.dup, 'Q' => SUITS.dup, 'K' => SUITS.dup,
            'A' => SUITS.dup
          }



end
