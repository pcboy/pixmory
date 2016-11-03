require 'rforvo'

require_relative 'core_module'

module Pixmory
  class Sound < CoreModule
    def initialize(deckname, word, lang)
      @lang = lang[0...-1] # kor -> ko
      @deck = deckname
      @word = word.split('/').first.strip || '' # word1 / word2 can be present. Take first. 
    end
      
    def to_s
      File.exists?(fullpath) ? %Q{[sound:#{filename}]} : ''
    end 
      
    def save
      unless File.exists?(fullpath)
        if url = pronunciation(@word)
          save_url(fullpath, url)
        end
      end
    end 
      
    private

    def fullpath
      "#{@deck}/#{@deck}.media/#{filename}"
    end

    def filename
      "pixmory-#{@deck}-#{URI::escape(@word)}.mp3"
    end 
      
    def pronunciation(word)
      forv = Rforvo::Rforvo.new(@lang)
      forv.standard_pronunciation(word)
    end
  end
end
