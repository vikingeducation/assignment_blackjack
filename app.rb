require "sinatra"
require "sinatra/reloader" if development?
require "pry"

get "/" do
  erb :home
end

get "/blackjack" do
  erb :blackjack
end
