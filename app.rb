require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

class Deck
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
  @deck = Deck.new
  @player = Player.new
  @dealer = Dealer.new

  # deal cards to Dealer and Player
  2.times { @player.hand << @deck.deal_card }
  2.times { @dealer.hand << @deck.deal_card }

  # main game view
  erb :blackjack
end
