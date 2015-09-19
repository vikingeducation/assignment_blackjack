#!/usr/bin/env ruby
require 'sinatra'
require 'json'
enable :sessions

require './deck.rb'

require './helpers/hand_calculator.rb'

helpers HandCalculator

get '/' do
  erb :home
end


get '/blackjack' do
  # saved_deck = session[:deck].nil? ? nil : JSON.parse( session[:deck] )
  @deck = Deck.new
  @player_hand = [@deck.deal_card, @deck.deal_card]
  @dealer_hand = [@deck.deal_card, @deck.deal_card]
  @reveal = false

  session[:deck] = @deck.cards.to_json
  session[:player_hand] = @player_hand.to_json
  session[:dealer_hand] = @dealer_hand.to_json

  erb :blackjack
end


get '/blackjack/hit' do
  @deck = Deck.new( JSON.parse( session[:deck] ) )
  @player_hand = JSON.parse( session[:player_hand] )
  @dealer_hand = JSON.parse( session[:dealer_hand] )

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
  @reveal = true

  loop do 
    if total_hand(@dealer_hand) == 17 && aces_in_hand?(@dealer_hand)
      break
    elsif total_hand(@dealer_hand) >= 17
      break
    else
      @dealer_hand << @deck.deal_card
    end
  end

  if draw?(@player_hand, @dealer_hand)
    @message = "Its a Draw!"
  elsif busted?(@player_hand) && busted?(@dealer_hand)
    @message = "Dealer and Player both busted!"
  else
    winner = winner?(@player_hand, @dealer_hand)
    @message = "#{winner[0]} wins with #{winner[1]}!"
  end

  erb :blackjack
end
