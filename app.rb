require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

enable :sessions

class Blackjack
  attr_reader :cards

  def initialize(cards = nil)
    @cards = cards || generate_cards
  end

  # generates a standard 52 card deck
  def generate_cards
    suits = [:spades, :hearts, :clubs, :diamonds]
    values = (2..10).to_a
    values << [:ace, :jack, :queen, :king]
    values.flatten!

    values.product(suits).shuffle
  end

  # deals a card from the top of the deck
  def deal_card
    @cards.shift
  end

  # helper method to print out a card in a better-looking format
  def render(card)
    "#{card[0].to_s.capitalize} of #{card[1].to_s.capitalize}"
  end

  # calculates the points value of a hand
  def points(hand)
    points = 0

    hand.each do |card|
      case(card[0])
      when :ace
        points += 11
        points -= 10 if points > 21
      when :jack, :queen, :king
        points += 10
      else
        points += card[0]
      end
    end

    points
  end

  # checks if a hand is busted
  def busted?(hand)
    self.points(hand) > 21
  end
end

class Player
  attr_accessor :hand

  def initialize(hand = nil)
    @hand = hand || []
  end
end

class Dealer
  attr_accessor :hand

  def initialize(hand = nil)
    @hand = hand || []
  end
end

# root route
get '/' do
  erb :home
end

# main game route
get '/blackjack' do
  # reinstantiate / create new objects
  @blackjack = Blackjack.new(session[:deck_cards])
  @player = Player.new(session[:player_hand])
  @dealer = Dealer.new(session[:dealer_hand])
  @round_over = false

  # deal cards to Dealer and Player
  2.times { @player.hand << @blackjack.deal_card } if @player.hand.empty?
  2.times { @dealer.hand << @blackjack.deal_card } if @dealer.hand.empty?

  # save objects' state to session
  session[:deck_cards] = @blackjack.cards
  session[:player_hand] = @player.hand
  session[:dealer_hand] = @dealer.hand

  # main game view
  erb :blackjack
end

# route for player to hit
post '/blackjack/hit' do
  # reinstantiate objects
  @blackjack = Blackjack.new(session[:deck_cards])
  @player = Player.new(session[:player_hand])
  @dealer = Dealer.new(session[:dealer_hand])
  @round_over = false

  # deal card to Player
  @player.hand << @blackjack.deal_card

  # redirect if player has busted
  redirect to('/blackjack/stay') if @blackjack.busted?(@player.hand)

  # save objects' state to session
  session[:deck_cards] = @blackjack.cards
  session[:player_hand] = @player.hand

  # render view
  erb :blackjack
end

# route for player to stay
get '/blackjack/stay' do
  # reinstantiate objects
  @blackjack = Blackjack.new(session[:deck_cards])
  @player = Player.new(session[:player_hand])
  @dealer = Dealer.new(session[:dealer_hand])

  # Dealer hits until at least 17 points
  @dealer.hand << @blackjack.deal_card until @blackjack.points(@dealer.hand) >= 17

  # save objects' state to session
  session[:deck_cards] = @blackjack.cards
  session[:player_hand] = @player.hand
  session[:dealer_hand] = @dealer.hand

  @round_over = true

  # render view
  erb :blackjack
end
