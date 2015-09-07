require 'rforvo'

require_relative 'core_module'

module Pixmory
  class Sound < CoreModule
    def initialize(deckname, word)
      @deck = deckname
      @word = word.split('/').first.strip || '' # word1 / word2 can be present. Take first. 
    end
      
    def to_s
      File.exists?(fullpath) ? %Q{[sound:#{filename}]} : ''
    end 
      
    def save
      if url = pronunciation(@word)
        save_url(fullpath, url)
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
