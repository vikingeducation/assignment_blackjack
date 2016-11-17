module BlackjackHelpers
  def deal
    values = (1..11).to_a

    hand = []

    2.times do
      hand << values.sample
    end

    hand
  end

  def bank
    bank_roll = 10_000
  end
end
