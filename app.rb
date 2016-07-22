require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do
  erb :home
end


get '/blackjack' do
 @deck = Deck.new

end