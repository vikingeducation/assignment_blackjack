class DeckEmptyError < StandardError
  def initialize(msg = "deck empty")
    super(msg)
  end
end
