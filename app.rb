require 'sinatra'
require 'erb'
require 'pry-byebug'
require './helpers/deck_helpers.rb'
require './player.rb'
require './deck.rb'
helpers DeckHelper
enable :sessions

get '/' do
  reset_bankroll
  erb :home
end

get '/bet' do
  erb :bet
end

post '/bet' do
  if valid_bet(params[:bet].to_i)
    set_player_bet(params[:bet].to_i)
    create_deck(reset_bankroll: false)
    if !player_blackjack && !dealer_blackjack
      erb :blackjack
    elsif player_blackjack && !dealer_blackjack
      @blackjack = true
      binding.pry
      redirect "/blackjack/stay"
    else
      redirect "/blackjack/stay"
    end
  else
    @error = "INSUFFICIENT_AMOUNT"
    erb :bet
  end
end

post '/blackjack/hit' do
  deal_player
  if player_busted? || player_blackjack
    redirect "/blackjack/stay"
  else
    erb :blackjack
  end
end

post '/blackjack/stay' do
  if !player_busted?
    while dealer_count < 17
      deal_dealer
    end
  end
  redirect "/blackjack/stay"
end

get '/blackjack/stay' do
  @winner = compare_hands
  @busted = busted_player
  erb :gameover
end