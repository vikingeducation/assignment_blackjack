

module Helper

	def parse_and_assign_variables

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
binding.pry
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
	  #session[ :deck   ] = nil

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

	def evaluate_hands

		dealer_hand = @game.evaluate_cards( @dealer )
		player_hand = @game.evaluate_cards( @player )

		if player_hand == 21 && @player.count == 2

			# blackjack and player gets paid 3:2
			# goes to player bankroll

		elsif dealer_hand > player_hand

			# dealer wins and bet is removed
			# new game is prompted
			# new bets are made

		elsif dealer_hand == player_hand

			# tie and bet goes back into player's bankroll
			# new game is prompted
			# new bets are made

		elsif dealer_hand < player_hand

			# player wins and players bet is multiplied by 2 and added to player bankroll
			# new game is prompted
			# new bets are made

		 end

	end


	def start_dealer_turn
		# pass total of dealer cards to dealer AI
		dealer_ai( @game.evaluate_cards( @dealer ) )

	end

	def dealer_ai( dealer_total )
		# dealer will hit until 17
		return if dealer_total >= 17

			@dealer += @game.hit
			start_dealer_turn

	end


end #./Module