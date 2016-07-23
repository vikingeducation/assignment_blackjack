#!/usr/bin/env ruby
# app.rb

require 'sinatra'
require './helpers/deck.rb'
require './helpers/game_helper.rb'
require 'pry-byebug'

helpers GameHelper
enable :sessions

get '/' do
  erb :home
end

get '/blackjack' do
  @deck = Deck.new
  @dealer_hand = @deck.deal
  @player_hand = @deck.deal
  save_game(@deck.deck, @dealer_hand, @player_hand)

  erb :hit, :layout => :layout,
    locals: { dealer_hand: @dealer_hand, player_hand: @player_hand }
end

post '/blackjack' do
  game = load_game
  @deck = Deck.new(game[:deck])
  @player_hand = game[:player_hand]
  @dealer_hand = game[:dealer_hand]
  save_game(@deck.deck, @dealer_hand, @player_hand)

  erb :hit, :layout => :layout,
    locals: { dealer_hand: @dealer_hand, player_hand: @player_hand }
end

post '/blackjack/hit' do
  game = load_game
  @deck = Deck.new(game[:deck])
  @player_hand = game[:player_hand]
  @dealer_hand = game[:dealer_hand]

  @player_hand << @deck.hit unless @deck.empty?

  if hand_total(@player_hand) > 21
    @deck.push(@player_hand.pop)
    save_game(@deck.deck, @dealer_hand, @player_hand)
    redirect to('/blackjack/stay')
  end

  save_game(@deck.deck, @dealer_hand, @player_hand)

  erb :hit, :layout => :layout,
    locals: { dealer_hand: @dealer_hand,
              player_hand: @player_hand }
end

post '/blackjack/stay' do
  game = load_game
  @deck = Deck.new(game[:deck])
  @player_hand = game[:player_hand]
  @dealer_hand = game[:dealer_hand]

  until hand_total(@dealer_hand) > 16 do
    @dealer_hand << @deck.hit unless @deck.empty?
  end

  if hand_total(@dealer_hand) > 21 ||
      hand_total(@dealer_hand) < hand_total(@player_hand)
    winner_flag = "Player"
  elsif hand_total(@dealer_hand) == hand_total(@player_hand)
    winner_flag = "tie"
  else
    winner_flag = "Dealer"
  end

  erb :gameover, :layout => :layout,
    locals: { dealer_hand: @dealer_hand,
              player_hand: @player_hand,
              winner_flag: winner_flag }
end

get '/blackjack/stay' do
  game = load_game
  @deck = Deck.new(game[:deck])
  @player_hand = game[:player_hand]
  @dealer_hand = game[:dealer_hand]

  until hand_total(@dealer_hand) > 16 do
    @dealer_hand << @deck.hit unless @deck.empty?
  end

  if hand_total(@dealer_hand) > 21 ||
      hand_total(@dealer_hand) < hand_total(@player_hand)
    winner_flag = "Player"
  elsif hand_total(@dealer_hand) == hand_total(@player_hand)
    winner_flag = "tie"
  else
    winner_flag = "Dealer"
  end

  erb :gameover, :layout => :layout,
    locals: { dealer_hand: @dealer_hand,
              player_hand: @player_hand,
              winner_flag: winner_flag }
end

get '/blackjack/hit' do
  redirect to('/')
end
