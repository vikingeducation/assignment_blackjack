#!/usr/bin/env ruby

require 'sinatra'
require 'erb'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do
  erb :index
end

get '/blackjack' do
  erb :blackjack
end
