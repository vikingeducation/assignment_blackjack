
require File.expand_path('player', File.dirname(__FILE__))

module Blackjack
  class User < Player
    attr_accessor :betting_pool

    def initialize(args = {})
      @betting_pool = args.fetch(:money, 10_000)
      super
    end

  end
end
