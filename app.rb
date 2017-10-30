require 'sinatra'
require "sinatra/reloader" if development?
require 'erb'
require 'pry'

# Helpers
require './helpers/blackjack_helper'
helpers BlackjackHelper

# Routes
enable :sessions

get '/' do
  erb :index
end

get '/blackjack' do
  @deck = build_deck
  erb :blackjack
end
