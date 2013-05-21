# -*- encoding : utf-8 -*-
#
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                  Version 2, December 2004
#
#  Copyright (C) 2004 Sam Hocevar
#  14 rue de Plaisance, 75014 Paris, France
#  Everyone is permitted to copy and distribute verbatim or modified
#  copies of this license document, and changing it is allowed as long
#  as the name is changed.
#  DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#
#
#  David Hagege <david.hagege@gmail.com>
#

require 'rtatoeba'
require 'furigana'

module Pixmory
  class Sentence

    def initialize(deckname, from_lang = 'eng', to_lang = 'eng',
                   from_word = '', to_word = '')
      @deck = deckname
      @from_lang, @to_lang = from_lang, to_lang
      @from_word = from_word
      @to_word = to_word.split('/').first.strip || ''
    end


    def to_s
      if File.exists?(fullpath)
        File.read(fullpath)
      else
        ''
      end
    end

    def save
      target = fullpath
      unless File.exists?(target)
        ap "#{filename} doesn't exist"
        ap sample_sentences
        if sentence = sample_sentences
          File.open(target, "wb") do |f|
            f << sentence
          end
        end
      end
    end

    private

    def fullpath
      "#{@deck}/tmp/#{filename}"
    end

    def filename
      "pixmory-#{@deck}-sentence-#{CGI::escape(@from_word)}.txt"
    end

    def sample_sentences
      tatoeba = Rtatoeba::Rtatoeba.new(from: @from_lang, to: @to_lang, query: @from_word)
      sentences = tatoeba.sentences
      # Take the shortest sentence which contains the from_word and to_ word
      shortest_value = sentences.values.sort_by{|x| x[0].length}
                                .select{|x| x[0].slice(/#{@to_word}/i)}
      shortest = shortest_value.flatten.first
      return '' if shortest.nil?
      if @to_lang == 'jpn'
        shortest = Furigana::Formatter::Text.format(shortest,
                                  Furigana::Reader.new.reading(shortest))
      end
      english = sentences.select{|k,v| v.include?(shortest)}.keys.first
      if english.nil? then '' else "<br>" + [english, shortest].join("<br>") end
    end
  end
end
