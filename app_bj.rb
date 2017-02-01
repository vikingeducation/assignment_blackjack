
require 'erb'
require 'pry-byebug'
require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?

get "/" do
  erb :home
end

get "/blackjack/game_view" do
  erb :"blackjack/game_view"
end