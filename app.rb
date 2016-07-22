#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/contrib'
require_relative 'deck'
require_relative 'blackjack'
require_relative 'player'
require_relative 'dealer'
require_relative 'helpers/blackjack_helpers'

enable :sessions

helpers BlackjackHelpers

get '/' do 
  session['bankroll'] ||= 1_000
  erb :home
end

get '/bet' do 
  erb :bet
end

post '/bet' do 
  if params[:bet_value].to_i > session['bankroll']
    session['bet_message'] = "You don't have that much guap."
    redirect '/bet'
  else
    session['bet'] = params[:bet_value]
    session['bankroll'] -= params[:bet_value]
    redirect '/blackjack'
  end
end

get '/blackjack' do
  game = Blackjack.new(session['deck'])
  game.start
  session['deck'] ||= game.deck.cards
  session['player_hand'] = game.player.hand
  session['dealer_hand'] = game.dealer.hand

  if game.player.blackjack?(game.player.hand)
    session['message'] = "You won!"
    redirect '/game_over'
  end
  erb :blackjack
end

post '/turn' do 

  game = Blackjack.new(session['deck'], session['player_hand'], session['dealer_hand'])

  if params[:hit] 
    game.player.hit(game.deck.cards)
    if game.game_over?(session['player_hand'])
      if game.player.bust?(session['player_hand'])
        session['message'] = "You busted."
      elsif game.player.blackjack?(session['player_hand']) && game.dealer.blackjack?(session['dealer_hand'])
        session['message'] = "You tied."
        session['bankroll'] += session['bet']
      else
        session['message'] = "You won!"
        session['bankroll'] += session['bet'] * 1.5
      end
      session['deck'] = game.deck.cards
      session['player_hand'] = game.player.hand
      session['dealer_hand'] = game.dealer.hand
      redirect '/game_over'
    end
  else 
    game.dealer.hit(game.deck.cards)
    session['deck'] = game.deck.cards
    session['dealer_hand'] = game.dealer.hand
    
   if game.dealer_wins?(session['player_hand'], session['dealer_hand'])
     session['message'] = "You lost, Dealer wins"
   else
     session['message'] = "You won!"
   end
    
    redirect '/game_over'
  end

  session['deck'] = game.deck.cards
  session['player_hand'] = game.player.hand
  session['dealer_hand'] = game.dealer.hand
  erb :blackjack
end

get '/game_over' do 
  session['bet_message'] = nil
  erb :game_over
end

# Deck class
  # #shuffle
  # deck is a hash of cards and number of each card remaining