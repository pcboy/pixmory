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

require 'wordref'
require 'maybe'
require 'uri'
require 'awesome_print'
require 'trollop'

require_relative 'config'

OPTS = Trollop::options do
  opt :wordfile, "File containing comma separated words to translate.",
    :type => String
  opt :from_lang, "Source language in the wordfile" \
    "(e.g ko,en, https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)",
    :type => String
  opt :to_lang, "Destination language" \
    "(e.g en,ko https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)",
    :type => String
  opt :output, "Destination filename", :type => String
end

unless OPTS[:wordfile] && File.exists?(OPTS[:wordfile])
  Trollop::die :wordfile, "must exists and be readable"
end

[:from_lang, :to_lang, :output].map do |required|
  if OPTS[required].nil? || OPTS[required].strip.empty?
    Trollop::die required, "must be specified"
  end
end

dic = Wordref::Wordref.new(WORDREFERENCE_API_KEY)

translated = []
open(OPTS[:wordfile]).read.split(',').map do |word|
  puts "->#{word}"
  word.strip!
  tr_word = dic.translate(from: OPTS[:from_lang], to: OPTS[:to_lang], word: word)
  if tr_word.nil?
    warn "No translation found for: #{word}"
  else
    puts "  #{tr_word}<-"
    translated << [word, tr_word.gsub(/,|、/, ' / ').strip]
  end
end

File.open(OPTS[:output], "w") { |f| f << translated.map { |x| x.join(',') }.join("\n") }
