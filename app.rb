require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

require './helpers/blackjack_helpers'
require './helpers/blackjack'
require './helpers/dealer'
require './helpers/player'

helpers BlackjackHelpers

enable :sessions

# root route
get '/' do
  erb :home
end

get '/bet' do
  @player = load_player

  erb :bet
end

post '/bet' do
  @player = load_player
  @blackjack = load_cards
  bet = params[:bet].to_i

  # validate that bet is valid, i.e. Player has enough money
  if @blackjack.valid_bet?(@player, bet)
    @player.place_bet(bet)
    save_player(@player)
    redirect to('/blackjack')
  else
    erb :bet, locals: { invalid_bet: true }
  end
end

# main game route
get '/blackjack' do
  # reinstantiate / create new objects
  @blackjack = load_cards
  @player = load_player
  @dealer = load_dealer

  # deal cards to Dealer and Player
  2.times { @player.hand << @blackjack.deal_card } if @player.hand.empty?
  2.times { @dealer.hand << @blackjack.deal_card } if @dealer.hand.empty?

  # save objects' state to session
  save_cards(@blackjack.cards)
  save_player(@player)
  save_dealer(@dealer.hand)

  # main game view
  erb :blackjack
end

# route for player to hit
post '/blackjack/hit' do
  # reinstantiate objects
  @blackjack = load_cards
  @player = load_player
  @dealer = load_dealer

  # deal card to Player
  @player.hand << @blackjack.deal_card

  # save objects' state to session
  save_cards(@blackjack.cards)
  save_player(@player)

  # redirect if player has busted
  redirect to('/blackjack/stay') if @blackjack.busted?(@player.hand)

  # render view
  erb :blackjack
end

# route for player to stay
get '/blackjack/stay' do
  # reinstantiate objects
  @blackjack = load_cards
  @player = load_player
  @dealer = load_dealer

  # Dealer hits until at least 17 points
  @dealer.hand << @blackjack.deal_card until @blackjack.points(@dealer.hand) >= 17

  # round is over, determine winner
  winner = @blackjack.winner(@dealer.hand, @player.hand)

  # payout the Player if he won or tie
  if winner == :tie
    @player.payout(@player.bet)
  elsif winner == :player
    @player.payout(@player.bet * 2)
  end

  # save Player balance
  save_player(@player)

  # clear session for next round
  next_round

  # render view
  erb :blackjack, locals: { winner: winner }
end
