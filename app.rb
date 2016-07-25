require 'sinatra'
require 'erb'
require './helpers/bj_help.rb'

enable :sessions

helpers BJ

get '/' do

  erb :home
end

get '/blackjack' do
  g = Game.new
  @phand = g.phand.show
  @dhand = g.dhand.show
  @deck = g.deck
  save_game(g)

  # new_deck
  # @phand = new_hand("player")
  # @dhand = new_hand("dealer")
  # @deck = session["deck"]
  erb :blackjack
end

post '/blackjack/hit' do

  game = restore_game
  game.hit(game.phand)
  save_game(game)
  @phand = game.phand.show
  @dhand = game.dhand.show
  @deck = game.deck
  if game.phand.sum >= 21
    redirect to('/blackjack/stay')
  else
    erb :blackjack
  end

end

get '/blackjack/stay' do
  @done = true
  game = restore_game
  until game.dhand.sum > 16
    game.hit(game.dhand)
  end
  save_game(game)
  @phand = game.phand.show
  @dhand = game.dhand.show
  @playersum = game.phand.sum
  @dealersum = game.dhand.sum
  erb :blackjack

end
