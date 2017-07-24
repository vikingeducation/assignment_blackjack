require 'sinatra'
require 'erb'
require 'json'
require 'pry-byebug'
require 'sinatra/reloader' if development?
require './helpers/blackjack_helpers.rb'


enable :sessions

helpers BlackJackHelpers

before do
  @deck = Deck.new
end

get '/' do
  erb :home
end

# starts bet before cards are dealt
get '/blackjack/bet' do
  @user = Player.new(@deck.deal_cards(2))
  @dealer = Player.new(@deck.deal_cards(2))
  save_variables
  erb :betting_form
end

post '/blackjack/bet' do
  restore_user && restore_dealer && restore_deck
  @user.bet = params[:bet].to_i
  save_variables
  if @user.bet > @user.bankroll
    erb :betting_form
  else
    redirect to('/blackjack/play')
  end
end

# shuffles deck and deal hands to dealer and player
get '/blackjack/play' do
  restore_user && restore_dealer && restore_deck
  @user.bankroll -= @user.bet
  @user_score = @user.get_score
  @dealer_score = @dealer.get_score
  save_variables
  if @user_score == 21 || @dealer_score == 21
    if @user_score == 21
      @user_bankroll += (@user.bet * 2.5)
    end
    erb :blackjack_win
  else
    erb :blackjack
  end
end

post "/blackjack/hit" do
  # adds a card to the players hand and re-renders the main page
  # if hitting would bust player (over 21 total) redirect to get /blackjack/stay
  # need to use cookies/session to keep track of cards already dealt?
  restore_deck && restore_user && restore_dealer
  @user.hand << @deck.deal_cards(1).flatten
  @user_score = @user.get_score
  @dealer_score = @dealer.get_score
  save_variables
  if @user_score >= 21
    redirect to('/blackjack/stay')
  end
  erb :blackjack
end

get '/blackjack/stay' do
  # gets dealer to play their hand - either hit or stay depending on if product is 17 or higher
  # render main page with all cards revealed and describes the result
  restore_deck && restore_user && restore_dealer
  @user_score = @user.get_score
  @dealer_score = @dealer.get_score
  if @user_score > 21
    save_variables
    erb :blackjack_stay
  else
    while @dealer_score <= 17
      @dealer.hand << @deck.deal_cards(1).flatten
      @dealer_score = @dealer.get_score
    end
    if @dealer_score > 21 ||
      (@dealer_score < 21 && @dealer_score < @user_score && @user_score < 21) ||
      @user_score == 21
      @user.bankroll += (@user.bet * 2)
    elsif @dealer_score == @user_score
      @user.bankroll += @user.bet
    end
  end
  save_variables
  erb :blackjack_stay
end

get '/blackjack/new_game' do
  redirect to('/blackjack/bet')
end

get '/blackjack/play_again' do
  @user = Player.new(@deck.deal_cards(2), session[:user_bankroll])
  @dealer = Player.new(@deck.deal_cards(2))
  save_variables
  erb :betting_form
end
