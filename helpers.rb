

module Helper

	def parse_and_assign_decks_hands

		parse_session
		assign_variables

	end


	def new_game

		@game = Deck.new( JSON.parse( session[ :deck ] ) )

	end


	def parse_and_assign_bankroll

		parse_bankroll
		assign_bankroll

	end

	def parse_bankroll

		if !session[ 'bankroll' ].nil?
			@bank = Bankroll.new( JSON.parse( session[ :bankroll   ] ),
												JSON.parse( session[ :bet ] )
											)
		else
			@bank = Bankroll.new
		end

	end

	def assign_bankroll

		@bankroll = @bank.bankroll
		@bet = @bank.bet

	end


	def clear_plyr_dlr

		session[ :player ] = nil
		session[ :dealer ] = nil

	end

	def save_session

		session[ :player ] = @player.to_json
		session[ :dealer ] = @dealer.to_json
	  session[ :deck   ] = @deck.to_json

	end

	def save_bank

	  session[ :bankroll ] = @bank.bankroll.to_i.to_json
	  session[ :bet      ] = @bank.bet.to_i.to_json

	end


	def bust?( total )

		!!( total > 21 )

	end


	def parse_session

		if !session[ :deck ].nil?
			@game = Deck.new( JSON.parse( session[ :deck   ] ),
												JSON.parse( session[ :player ] ),
												JSON.parse( session[ :dealer ] )

											)
		else
			@game = Deck.new
		end

	end


	def assign_variables

		@player = @game.player_cards
		@dealer = @game.dealer_cards
		@deck   = @game.deck

	end


	def start_dealer_turn

		dealer_ai( @game.evaluate_cards( @dealer ) )

	end

	def dealer_ai( dealer_total )

		return if dealer_total >= 17

			@dealer += @game.hit
			start_dealer_turn

	end


end