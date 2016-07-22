class Card
  attr_reader :suit, :rank
  def initialize(suit, rank, face_up = true)
    @suit = suit
    @rank = rank
    @face_up = face_up
  end

  def value
    convert_rank_to_value
  end

  def face_up?
    @face_up
  end

  def face_down?
    !@face_up
  end

  def flip
    @face_up ^= true
  end

  def rank_symbol
    convert_rank_to_symbol
  end

  def suit_symbol
    convert_suit_to_symbol
  end

  private

  def convert_rank_to_value
    if @rank.is_a?(Symbol)
      return 10 if [:jack, :queen, :king].include?(@rank)
    else
      @rank
    end
  end

  # Converts rank to a string for rendering
  def convert_rank_to_symbol
    @rank.is_a?(Symbol) ? @rank.to_s.chars.first.upcase : @rank.to_s
  end

  def convert_suit_to_symbol
    case @suit
    when :diamond
      encode("\u2666")
    when :heart
      encode("\u2665")
    when :club
      encode("\u2663")
    when :spade
      encode("\u2660")
    end
  end

  def encode(string)
    string.encode('utf-8')
  end
end
