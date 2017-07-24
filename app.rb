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
  @user = HumanPlayer.new(@deck.deal_cards(2))
  @dealer = Player.new(@deck.deal_cards(2))
  save_variables
  erb :betting_form
end

post '/blackjack/bet' do
  restore_variables
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
  restore_variables
  @user.bankroll -= @user.bet
  get_scores(@user, @dealer)
  save_variables
  if @user_score == 21 || @dealer_score == 21
    if @user_score == 21
      @user.bankroll += (@user.bet * 2.5)
    end
    erb :blackjack_win
  else
    erb :blackjack
  end
end


# adds a card to the players hand and re-renders the main page
# if hitting would bust player (over 21 total) redirect to get /blackjack/stay
post "/blackjack/hit" do
  restore_variables
  @user.hand << @deck.deal_cards(1).flatten
  get_scores(@user, @dealer)
  save_variables
  if @user_score >= 21
    redirect to('/blackjack/stay')
  end
  erb :blackjack
end


# gets dealer to play their hand - either hit or stay depending on if product is 17 or higher
# render main page with all cards revealed and describes the result
get '/blackjack/stay' do
  restore_variables
  get_scores(@user, @dealer)
  if @user_score > 21
    save_variables
    erb :blackjack_stay
  else
    dealers_turn(@dealer)
    @user.payout(@user_score, @dealer_score)
  end
  save_variables
  erb :blackjack_stay
end

get '/blackjack/new_game' do
  redirect to('/blackjack/bet')
end

get '/blackjack/play_again' do
  @user = HumanPlayer.new(@deck.deal_cards(2), session[:user_bankroll])
  @dealer = Player.new(@deck.deal_cards(2))
  save_variables
  erb :betting_form
end
