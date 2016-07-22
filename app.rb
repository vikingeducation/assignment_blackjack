require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/deck'

enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do

  deck = session["deck_arr"] ? Deck.new(session["deck_arr"]): Deck.new

    #show player and dealer hands



  erb :blackjack, locals: { deck: deck }
end


get '/blackjack/play' do
  erb :blackjack
end
# post '/blackjack/pass_deck' do

#   @deck = load_deck

# end