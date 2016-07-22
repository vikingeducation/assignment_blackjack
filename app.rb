require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do

  deck = Deck.new if new_game?
  
    #show player and dealer hands



  erb :blackjack, locals: { deck: deck}
end

# post '/blackjack/pass_deck' do

#   @deck = load_deck

# end