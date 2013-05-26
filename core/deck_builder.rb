module Pixmory
  class DeckBuilder
    attr_accessor :name, :cards

    def initialize(name, cards)
      @name = name
      @cards = cards
    end

    def save
      target = "#{@name}/#{@name}.txt"
      FileUtils.mkdir_p(File.dirname(target) + "/#{@name}.media")
      FileUtils.mkdir_p(File.dirname(target) + "/tmp")
      File.open(target, "wb") do |f|
        @cards.map do |c|
          c.save
          f << "#{c.front.compact.join('<br>')}\t#{c.back.compact.join('<br>')}<br>\n"
        end
      end
    end

  end
end
