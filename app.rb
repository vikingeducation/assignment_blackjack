#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require_relative "./helpers/bet_helper"
require_relative "./helpers/cards_helper"
require_relative "./helpers/blackjack_helper"
require_relative "./helpers/dealer_helper"

enable :sessions
helpers BetHelper, CardsHelper, BlackjackHelper, DealerHelper

get '/' do
  session.clear if params[:reset]

  bankroll = load_bankroll
  erb :landing, locals: { bankroll: bankroll}
end

get '/blackjack' do
  place_bet( params[:bet] ) unless params[:bet].nil?
  bet_placed = load_bet

  if bet_placed.nil? && session["player_cards"].nil?
    game_start

    redirect to('game_over') if blackjack?(session['player_cards'])
    redirect to('game_over') if blackjack?(session['dealer_cards'])
  end

  if params[:hit]
    hit_me(session['player_cards'])
    redirect to('game_over') if busted?(session['player_cards'])
  end

  if params[:double]

  end

  erb :blackjack, locals: {
                            bet_placed: bet_placed,
                            player_cards: session['player_cards'],
                            dealer_cards: session['dealer_cards'],
                          }
end

get '/game_over' do
  unless premature_win?
    dealer_play
  end

  outcome = get_outcome
  payout_bet

  p_cards = session['player_cards']
  d_cards = session['dealer_cards']
  bet = session['bet']
  bankroll = session['bankroll']

  session.clear
  session['bankroll'] = bankroll

  erb :game_over, locals: {
                            outcome: outcome,
                            player_cards: p_cards,
                            dealer_cards: d_cards,
                            player_points: sum_points( p_cards ),
                            dealer_points: sum_points( d_cards ),
                            bet: bet,
                            bankroll: bankroll
                          }
end
