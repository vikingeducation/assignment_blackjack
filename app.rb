require 'sinatra'
require 'erb'
require 'pry'
require 'json'
require 'sinatra/partial'
require_relative 'card_deck'
require_relative 'player'
require_relative 'helpers/blackjack_helper'

helpers BlackjackHelper

# saves deck and hands
enable :sessions

# options for partials
set :partial_template_engine, :erb
enable :partial_underscores

get '/' do
  erb :index
end

get '/blackjack' do
  if session[:deck_arr]
    @deck = load_deck
  else
    redirect to ('/blackjack/new')
  end

  player_hand = load_hand(session[:player_hand])
  dealer_hand = load_hand(session[:dealer_hand])
  bet = session[:bet]
  bankroll = session[:bankroll]

  if session[:winner]
    winner = session[:winner]
    scores = JSON.parse(session[:scores])
    if winner == 'you'
      if session[:blackjack]
        bankroll += bet * 3
      else
        bankroll += bet * 2
      end
    elsif winner == 'draw'
      bankroll += bet
    end

    session[:bankroll] = bankroll
    session[:bet] = nil
    session[:blackjack] = nil

    erb :final, locals: {player_hand: player_hand, dealer_hand: dealer_hand, winner: winner, scores: scores, bet: bet, bankroll: bankroll}
  else
    erb :blackjack, locals: {player_hand: player_hand, dealer_hand: dealer_hand, bet: bet, bankroll: bankroll}
  end
end

post '/blackjack/hit' do
  @deck = load_deck
  player_hand = load_hand(session[:player_hand])

  values = @deck.hand_values(player_hand)
  if @deck.bust?(values)
    redirect to('/blackjack/stay')
  else
    @deck.hit(player_hand)
    session[:deck_arr] = @deck.deck_arr.to_json
    session[:player_hand] = player_hand.to_json

    redirect to('/blackjack')
  end
end

get '/blackjack/player/new' do
  player = Player.new
  bankroll = player.bankroll
  session[:bankroll] = bankroll

  redirect to('/blackjack/bet')
end

get '/blackjack/bet' do
  bankroll = session[:bankroll]
  erb :bet_form, locals: {bankroll: bankroll}
end

post '/blackjack/bet' do
  # TODO:  add error checking
  bet = params[:bet].to_i
  session[:bankroll] -= bet
  session[:bet] = bet

  redirect to('/blackjack/new')
end

get '/blackjack/new' do
  @deck = CardDeck.new

  @deck.deal(@deck.deck_arr)
  player_hand = @deck.player_hand
  dealer_hand = @deck.dealer_hand
  session[:player_hand] = player_hand.to_json
  session[:dealer_hand] = dealer_hand.to_json

  if @deck.blackjack?
    set_winner_and_scores(player_hand, dealer_hand)
    session[:blackjack] = true
    redirect to('/blackjack')
  else
    session[:deck_arr] = @deck.deck_arr.to_json
    session[:scores] = nil
    session[:winner] = nil
    redirect to('/blackjack')
  end
end

get '/blackjack/stay' do
  @deck = load_deck
  dealer_hand = load_hand(session[:dealer_hand])
  player_hand = load_hand(session[:player_hand])

  loop do
    values = @deck.hand_values(dealer_hand)
    break if @deck.stop?(values)
    @deck.hit(dealer_hand)
  end
  session[:dealer_hand] = dealer_hand.to_json

  set_winner_and_scores(player_hand, dealer_hand)
  redirect to('/blackjack')
end