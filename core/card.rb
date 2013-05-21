require 'awesome_print'

module Pixmory
  class Card
    attr_accessor :front, :back
      
    def initialize(front = [], back = [])
      @front = front
      @back = back
    end
      
    def save
      (@front + @back).map do |item|
        item.save if item.respond_to?(:save)
      end
    end

  end
end
