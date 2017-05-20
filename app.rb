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

# main game route
get '/blackjack' do
  # reinstantiate / create new objects
  @blackjack = load_cards
  @player = load_player
  @dealer = load_dealer
  @round_over = false

  # deal cards to Dealer and Player
  2.times { @player.hand << @blackjack.deal_card } if @player.hand.empty?
  2.times { @dealer.hand << @blackjack.deal_card } if @dealer.hand.empty?

  # save objects' state to session
  save_cards(@blackjack.cards)
  save_player(@player.hand)
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
  @round_over = false

  # deal card to Player
  @player.hand << @blackjack.deal_card

  # redirect if player has busted
  redirect to('/blackjack/stay') if @blackjack.busted?(@player.hand)

  # save objects' state to session
  save_cards(@blackjack.cards)
  save_player(@player.hand)

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
  @round_over = true
  @winner = @blackjack.winner(@dealer.hand, @player.hand)

  # clear objects' state from session for new round
  reset_game

  # render view
  erb :blackjack
end
