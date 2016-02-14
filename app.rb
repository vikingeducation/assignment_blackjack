=begin
  2. Shuffle up and Deal

  The hand typically begins by placing a bet but we'll skip that functionality for now. There should be no styling done on the view templates.

  1. Start the game by building a basic home template (blackjack.erb) which will show player and dealer hands (as well as total player bankroll and bet amounts later). Remember that these things will need to be persisted to the browser between requests. (DONE)

  2. The get '/blackjack' route should shuffle up and deal hands to the dealer and the player, rendering the template with these things filled in. (DONE)

  3. Create any supporting classes you need to make the game go.
  Hint: a great method to explore for building the deck is product (DONE)

  # I'm thinking he wants us to combine two arrays, one that goes from A to K and another that has the suits. (DONE)

  4. The player's turn comes first. You should have buttons available to HIT or STAY.
    HIT will go to post '/blackjack/hit', which adds a card to the player's hand and re-renders the main page. (DONE)

  5. If the player hitting would bust that player (bring the total over 21 points), redirect to get /blackjack/stay.

  6. STAY will go to get '/blackjack/stay', which triggers the dealer to play his hand (hitting until 17). Once the dealer's hand is finished, render the main page with cards revealed and a message describing the result.

  7. Now stop and take a minute to examine your Request and Response objects in your terminal so you understand what is going on. Use a binding.pry or see This Stack Overflow Post for another way to check out the request. This is useful so you get an idea of where the cookies come from.
  Don't forget to commit!

=end

require 'sinatra'
require 'json'
require './helpers/blackjack_helpers'

helpers BlackjackHelpers

enable :sessions

class Deck
  attr_reader :deck
  # initialize a new deck
  def initialize(deck=nil)
    if deck == nil
      @deck = ('2'..'10').to_a
      ['J','Q','K','A'].each { |word_cards| @deck << word_cards }
      @deck = @deck.product(['C','S','H','D']).shuffle
    else
      @deck = deck.shuffle
    end
  end
end

class Computer

end

class Player

end

get '/' do
  erb :home
end

get '/blackjack' do
  deck = Deck.new.deck
  players_cards = []
  dealers_cards = []
  players_cards << deck.pop
  dealers_cards << deck.pop
  players_cards << deck.pop
  dealers_cards << deck.pop
  save_deck(deck)
  save_players_cards(players_cards)
  save_dealers_cards(dealers_cards)
  erb :blackjack, locals: {players_cards: players_cards, dealers_cards: dealers_cards, player_finished: false}
  # No shortcuts!!
  # You know what, we gotta save these to the sessions
  # To do that we need to use sessions and JSON
end

post '/blackjack/hit' do
  deck = load_deck
  players_cards = load_players_cards
  dealers_cards = load_dealers_cards
  players_cards << deck.pop
  save_deck(deck)
  save_players_cards(players_cards)
  save_dealers_cards(dealers_cards)
  if player_total[0] <= 21
    erb :blackjack, locals: {players_cards: players_cards, dealers_cards: dealers_cards, player_finished: false, player_total: player_total}
  else
    redirect to('blackjack/busted')
  end
end

get '/blackjack/busted' do
  players_cards = load_players_cards
  dealers_cards = load_dealers_cards
  erb :blackjack, locals: {players_cards: players_cards, dealers_cards: dealers_cards, player_finished: true, dealer_total: dealer_total}
end