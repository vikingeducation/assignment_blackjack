#!/usr/bin/env ruby

require 'sinatra'
require 'erb'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do
  erb :index
end

get '/blackjack' do

# create player and dealer

  erb :blackjack, locals: { player: player, 
                            dealer: dealer
                          }
end
