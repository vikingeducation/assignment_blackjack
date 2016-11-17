#!/usr/bin/env ruby

require 'sinatra'
require 'erb'
require 'sinatra/reloader' if development?
require File.expand_path('./helpers/blackjack', File.dirname(__FILE__))

enable :sessions

helpers Blackjack

get '/' do
  erb :index
end

get '/blackjack' do

  player = Blackjack::User.new(session[:user_hand])
  dealer = Blackjack::Dealer.new(session[:dealer_hand])

  erb :blackjack, locals: { player: player,
                            dealer: dealer }
end
