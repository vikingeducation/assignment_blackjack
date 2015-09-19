#!/usr/bin/env ruby
require 'sinatra'
require 'json'
enable :sessions

require './deck.rb'

require './helpers/hand_helper.rb'

helpers HandHelper


get '/' do
  session[:bankroll] = nil
  erb :home
end


get '/bet' do
  @bankroll = session[:bankroll].nil? ? 1000 : session[:bankroll]
  session[:bankroll] = @bankroll
  erb :place_bet
end


post '/bet' do 
  @bankroll = session[:bankroll]
  bet = params[:amount].to_i
  if bet <= @bankroll
    session[:bankroll] -= bet
    session[:bet] = bet
    redirect to('/blackjack')
  else
    @message = "You can't bet that much!"
    erb :place_bet
  end
end


get '/blackjack' do
  @deck = Deck.new
  @player_hand = [@deck.deal_card, @deck.deal_card]
  @dealer_hand = [@deck.deal_card, @deck.deal_card]
  @bet = session[:bet]
  @hand_over = false

  session[:deck] = @deck.cards.to_json
  session[:player_hand] = @player_hand.to_json
  session[:dealer_hand] = @dealer_hand.to_json

  # Checks for 21 on deal
  if blackjack?(@player_hand) && blackjack?(@dealer_hand)
    @hand_over = true
    session[:bankroll] += @bet
    @message = "You were both dealt 21, its a tie!"
  elsif blackjack?(@dealer_hand)
    @hand_over = true
    @message = "Dealer dealt 21, you lose!"
  elsif blackjack?(@player_hand)
    @hand_over = true
    session[:bankroll] += @bet * 2.5
    @message = "Blackjack!  You Win!"
  end

  @bankroll = session[:bankroll]

  erb :blackjack
end


get '/blackjack/hit' do
  @deck = Deck.new( JSON.parse( session[:deck] ) )
  @player_hand = JSON.parse( session[:player_hand] )
  @dealer_hand = JSON.parse( session[:dealer_hand] )
  @bankroll = session[:bankroll]
  @bet = session[:bet]

  @player_hand << @deck.deal_card

  session[:deck] = @deck.cards.to_json
  session[:player_hand] = @player_hand.to_json

  if busted?(@player_hand)
    redirect to('/blackjack/stay')
  else
    @message = "Player Hits!"
    erb :blackjack
  end
end


get '/blackjack/stay' do
  @deck = Deck.new( JSON.parse( session[:deck] ) )
  @player_hand = JSON.parse( session[:player_hand] )
  @dealer_hand = JSON.parse( session[:dealer_hand] )
  @bet = session[:bet]
  @hand_over = true

  # Dealer logic
  loop do 
    if total_hand(@dealer_hand) == 17 && aces_in_hand?(@dealer_hand)
      break
    elsif total_hand(@dealer_hand) >= 17
      break
    else
      @dealer_hand << @deck.deal_card
    end
  end

  # Determine game results
  if draw?(@player_hand, @dealer_hand)
    @message = "Its a Draw!"
    session[:bankroll] += @bet
  elsif busted?(@player_hand) && busted?(@dealer_hand)
    @message = "Dealer and Player both busted!"
  else
    winner = winner?(@player_hand, @dealer_hand)
    @message = "#{winner[0]} wins with #{winner[1]}!"
    if winner[0] == :Player 
      session[:bankroll] += @bet * 2
    end
  end

  @bankroll = session[:bankroll]

  erb :blackjack
end
