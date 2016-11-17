#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require_relative "./helpers/blackjack_helper"

enable :sessions
helpers BlackjackHelper

get '/' do
  bankroll = load_bankroll
  erb :landing, locals: { bankroll: bankroll}
end

get '/blackjack' do
  bet_placed = load_bet
  erb :blackjack, locals: {bet_placed: bet_placed}
end
