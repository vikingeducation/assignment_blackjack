require 'sinatra'
require 'erb'
require 'json'
require 'pry-byebug'
require 'sinatra/reloader' if development?

enable :sessions

helpers do

  def build_deck
    face = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
    suit = ["hearts", "spades", "clubs", "diamonds"]
    @deck = face.product(suit)
  end

  def deal_cards(num_of_cards)
    hand = @deck.sample(num_of_cards)
    hand.each do |card_in_hand|
      @deck.delete_if { |card_in_deck| card_in_deck == card_in_hand }
    end
    hand
  end

  def save_variables
    session[:dealer] = @dealer
    session[:player] = @player
    session[:deck] = @deck
  end

  def restore_variables
    @dealer = session[:dealer]
    @player = session[:player]
    @deck = session[:deck]
  end

  def get_player_score(player)
    scores = {
      '2' => 2,
      '3' => 3,
      '4' => 4,
      '5' => 5,
      '6' => 6,
      '7' => 7,
      '8' => 8,
      '9' => 9,
      '10' => 10,
      'J' => 10,
      'Q' => 10,
      'K' => 10,
      'A' => 11
    }
    score = player.reduce(0) do |s, i|
      s += scores[i[0].to_s]
    end

    if score > 21 && player.any? {|x| x[0] == "A"}
      score = score - 10
    end

    score
  end

end

before do
  build_deck
end


get '/' do
  erb :home
end


# needs to shuffle deck and deal hands to dealer and player
get '/blackjack' do
  @dealer = deal_cards(2)
  @player = deal_cards(2)
  @player_score = get_player_score(@player)
  @dealer_score = get_player_score(@dealer)
  if @player_score == 21 || @dealer_score == 21
    erb :blackjack_win
  else
    save_variables
    erb :blackjack # renders these things
  end
end

post "/blackjack/hit" do
  # adds a card to the players hand and re-renders the main page
  # if hitting would bust player (over 21 total) redirect to get /blackjack/stay
  # need to use cookies/session to keep track of cards already dealt?
  restore_variables
  @player << deal_cards(1).flatten
  puts "#{@player.class}"
  @player_score = get_player_score(@player)
  @dealer_score = get_player_score(@dealer)
  save_variables
  if @player_score >= 21
    redirect to('/blackjack/stay')
  end
  erb :blackjack
end

get '/blackjack/stay' do
  # gets dealer to play their hand - either hit or stay depending on if product is 17 or higher
  # render main page with all cards revealed and describes the result
  restore_variables
  @player_score = get_player_score(@player)
  @dealer_score = get_player_score(@dealer)
  while @dealer_score <= 17
    @dealer << deal_cards(1).flatten
    @dealer_score = get_player_score(@dealer)
  end
  erb :blackjack_stay
end

get '/blackjack/play_again' do
  erb :home
end
