
require File.expand_path('player', File.dirname(__FILE__))

module Blackjack

  class User < Player

    attr_accessor :betting_pool

    def initialize(args = {})
      @betting_pool = args[:money] || 10_000
      super
    end

    def betting_view
      "$#{betting_pool.to_s.reverse.gsub(/(\d{3})/,"\\1,").chomp(",").reverse}"
    end

  end
end
