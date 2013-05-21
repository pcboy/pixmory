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

require_relative 'config'

file = ARGV.shift

if file.nil?
  warn "Put a file to translate as first argument"
  exit
end

dic = Wordref::Wordref.new(WORDREFERENCE_API_KEY)

translated = []
open(file).read.split(',').map do |word|
  puts "->#{word}"
  word.strip!
  tr_word = dic.translate(from: 'en', to:'ja', word: word)
  if tr_word.nil?
    warn "No translation found for: #{word}"
  else
    puts "  #{tr_word}<-"
    translated << [word, tr_word.gsub(/,|、/, ' / ').strip]
  end
end

File.open("translated_#{file}", "w") { |f| f << translated.map { |x| x.join(',') }.join("\n") }
