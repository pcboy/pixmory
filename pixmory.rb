#!/usr/bin/env ruby
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


require 'open-uri'
require 'awesome_print'
require 'attempt'
require 'trollop'
require 'imgin'

require 'rtatoeba'

require_relative 'core/card'
require_relative 'core/deck_builder'
require_relative 'core/sound'
require_relative 'core/pic'
require_relative 'core/sentence'
require_relative 'core/furigana'

module Pixmory
  class Pixmory
    def initialize(params = {})
      @wordfile = params[:wordfile]
      @deckname = params[:deckname]
      @from_lang, @to_lang = params[:from_lang], params[:to_lang]
    end

    def start
      cards = []
      open(@wordfile).each_line do |words|
        source, target = words.split(',').map{|x| x.strip}
        next if target.nil? || target.empty?
        cards << Card.new(front(source, target),
                          back(source, target))
      end

      deck = DeckBuilder.new(@deckname, cards)
      deck.save
    end

    private

    def back(source, target)
      res = [target]
      if OPTS[:furigana] == true && @to_lang == 'jpn'
        res << Furi.new(target)
      end
      if OPTS[:sentence]
        res << Sentence.new(@deckname, @from_lang, @to_lang,
                             source, target)
      end
      res << Sound.new(@deckname, target, @to_lang) if OPTS[:pronunciation]
      res
    end

    def front(source, target)
      res = [source]
      if OPTS[:furigana] == true && @from_lang == 'jpn'
        res << Furi.new(source)
      end
      res << Pic.new(@deckname, source, @to_lang) if OPTS[:pictures]
      res
    end

  end
end

OPTS = Trollop::options do
  opt :wordfile, "File containing words and their translation comma separated",
    :type => String
  opt :deckname, "Name of the deck you want to create", :type => String
  opt :from_lang, "Source language in the wordfile" \
    "(e.g kor,eng, https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes)",
    :type => String
  opt :to_lang, "Destination language in the wordfile" \
    "(e.g eng, https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes)",
    :type => String
  opt :pronunciation, "Use forvo.com pronunciations on cards",
    :default => true
  opt :pictures, "Show pictures on cards",
    :default => true
  opt :furigana, "Use furiganas on cards (only works with Japanese)",
    :default => true
  opt :sentence, "Show sample sentences on cards",
    :default => true
end

unless OPTS[:wordfile] && File.exists?(OPTS[:wordfile])
  Trollop::die :wordfile, "must exists and be readable" 
end

[:deckname, :from_lang, :to_lang].map do |required|
  if OPTS[required].nil? || OPTS[required].strip.empty?
    Trollop::die required, "must be specified" 
  end
end

pix = Pixmory::Pixmory.new(wordfile: OPTS[:wordfile], deckname: OPTS[:deckname],
                           from_lang: OPTS[:from_lang], to_lang: OPTS[:to_lang])
pix.start
