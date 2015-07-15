#!/usr/bin/env ruby

require 'thin'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'pry'


get '/' do

  erb :layout

end

get '/blackjack' do

  

end