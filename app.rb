require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

class Deck
  attr_reader :cards

  def initialize
    @cards = generate_cards
  end

  # generates a standard 52 card deck
  def generate_cards
    suits = [:spades, :hearts, :clubs, :diamonds]
    values = (2..10).to_a
    values << [:ace, :jack, :queen, :king]
    values.flatten!

    values.product(suits).shuffle
  end
end


# root route
get '/' do
  erb :home
end

# main game route
get '/blackjack' do
  @deck = Deck.new

  # main game view
  erb :blackjack
end
