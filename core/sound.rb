require 'rforvo'

module Pixmory
  class Sound
    def initialize(deckname, word)
      @deck = deckname
      @word = word.split('/').first.strip || '' # word1 / word2 can be present. Take first. 
    end
      
    def to_s
      File.exists?(fullpath) ? %Q{[sound:#{filename}]} : ''
    end 
      
    def save
      target = fullpath
      unless File.exists?(target)
        ap "#{filename} doesn't exist"
        if url = pronounciation(@word)
          File.open(target, "wb") do |f|
            ap url
            attempt(2, 2) { 
              open(url, 'rb') { |rf| f.write(rf.read) }
            }
          end 
        end 
      end 
    end 
      
    private

    def fullpath
      "#{@deck}/#{@deck}.media/#{filename}"
    end

    def filename
      "pixmory-#{@deck}-#{CGI::escape(@word)}.mp3"
    end 
      
    def pronounciation(word)
      forv = Rforvo::Rforvo.new(FORVO_API_KEY)
      forv.standard_pronounciation(word)
    end
  end
end
