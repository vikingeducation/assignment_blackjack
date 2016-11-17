#!/usr/bin/env ruby

require 'sinatra'
require 'erb'
require 'sinatra/reloader' if development?

enable :sessions