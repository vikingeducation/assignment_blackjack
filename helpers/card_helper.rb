module CardHelper
	def card_image_filename(card)
		suit = card[0]
		value = card[1]
		value = value.to_s.length == 1 ? "0#{value}" : value.to_s
		"#{suit}#{value}.png"
	end

	def card_back_image_filename
		"back.png"
	end
end