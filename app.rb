#!/usr/bin/env ruby

require 'sinatra'
require 'erb'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do
  "<h1>Hello World</h1>"
end