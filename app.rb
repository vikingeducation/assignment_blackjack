require "sinatra"
require "sinatra/reloader" if development?
require "pry"
require_relative "deck"

enable :sessions

get "/" do
  erb :home
end

get "/blackjack" do

  if session["deck"]
    @deck = session["deck"]
    @player_hand = session["player_hand"]
    @dealer_hand = session["dealer_hand"]
  else
    @deck = Deck.new.deck
    @player_hand = []
    @dealer_hand = []
    2.times do
      @player_hand << @deck.pop
      @dealer_hand << @deck.pop
    end
  end

  session["deck"] = @deck
  session["player_hand"] = @player_hand
  session["dealer_hand"] = @dealer_hand


  erb :blackjack 
end

