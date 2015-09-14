require 'sinatra'
require 'uri'

require_relative 'lib/hand.rb'
require_relative 'lib/dealer.rb'

require_relative 'helpers/card_helper.rb'
helpers CardHelper

enable :sessions

helpers do
	def get_player
		session[:player] ? session[:player] : Player.new
	end

	def get_dealer
		session[:dealer] ? session[:dealer] : Dealer.new
	end

	def winner
		player = get_player
		dealer = get_dealer
		if dealt?
			if dealer.bust?
				result = player
			elsif player.bust?
				result = dealer
			elsif dealer.blackjack?
				result = dealer
			elsif player.blackjack?
				result = player
			elsif player.staying?
				if dealer.ties?(player) || dealer.beats?(player)
					result = dealer
				elsif player.beats?(dealer)
					result = player
				end
			end
		end
		result
	end

	def winnings
		player = get_player
		if winner == player
			ratio = player.blackjack? ? [3, 2] : [1, 1]
			pot = session[:pot]
			numerator = ratio[0]
			denominator = ratio[1]
			payout = (pot / denominator) * numerator
			amount = pot + payout
		end
		amount
	end

	def dealt?
		!get_dealer.hand.cards.empty? && !get_player.hand.cards.empty?
	end

	def session?
		session[:player] || session[:dealer] || session[:pot]
	end
end

get '/' do
	redirect '/reset' if session?
	erb :'layout.html' do
		erb :'index.html'
	end
end

get '/reset' do
	session.clear
	redirect '/'
end

get '/blackjack' do
	dealer = get_dealer
	player = get_player

	redirect '/blackjack/new' unless session?
	session[:winner] = winner

	amount = winnings
	player.bank += amount if amount

	locals = {
		:dealer => dealer,
		:player => player,
		:pot => session[:pot],
		:winner => session[:winner],
		:winnings => amount
	}

	erb :'layout.html' do
		erb :'game.html', :locals => locals
	end
end

get '/blackjack/new' do
	dealer = get_dealer
	player = get_player
	dealer.reset
	player.reset
	session[:player] = player
	session[:dealer] = dealer
	session[:pot] = 0
	message = 'Play Blackjack!'
	redirect "/blackjack?notice=#{message}"
end

get '/blackjack/deal' do
	unless dealt?
		dealer = get_dealer
		player = get_player
		dealer.deal(player)
		message = 'Dealt! Hit or stay?'
		redirect "/blackjack?notice=#{message}"
	else
		message = 'Cannot deal what has already been dealt!'
		redirect "/blackjack?error=#{message}"
	end
end

get '/blackjack/hit' do
	if dealt?
		player = get_player
		dealer = get_dealer
		unless player.bust?
			dealer.hit(player)
			message = 'Player takes a hit!'
			redirect "/blackjack?notice=#{message}"
		else
			message = 'You do realize you are already over 21 right?'
			redirect = "/blackjack?error?=#{message}"
		end
	else
		message = 'Start a game to take a hit!'
		redirect "/blackjack?error=#{message}"
	end
end

get '/blackjack/stay' do
	player = get_player
	if dealt?
		if player.staying?
			message = "You already stayed, you can't stay any further!"
			redirect "/blackjack?error=#{message}"
		elsif player.bust?
			message = "Bet you wish you stayed before you busted huh?"
			redirect "/blackjack?error=#{message}"
		else
			player.stay
			dealer = get_dealer
			dealer.turn
			redirect "/blackjack"
		end
	else
		message = 'You cannot stay if you have no cards...'
		redirect "/blackjack?error=#{message}"
	end
end

post '/blackjack/bet' do
	player = get_player
	unless dealt?
		amount = params[:bet]
		if amount =~ /(?!0)[0-9]+/ && player.bank >= amount.to_i
			player.bet(amount.to_i)
			session[:pot] += amount.to_i
			redirect '/blackjack/deal' unless dealt?
		else
			message = "You can't bet '#{amount}' dollars... nice try though!"
			redirect "/blackjack?error=#{message}"
		end
	else
		message = 'Cannot bet after cards have been dealt!'
		redirect "/blackjack?error=#{message}"
	end
end





