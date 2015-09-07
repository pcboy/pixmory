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

open('test_words', 'w') { |f| f.puts(File.read('sample_words').split(',').take(5).join(',')) }
`bundle exec ruby translate.rb --wordfile test_words --from-lang en --to-lang ko -o translated_test_words.korean`
raise "can't translate" if File.read('translated_test_words.korean').split("\n").count != 5

`bundle exec ruby pixmory.rb --wordfile translated_test_words.korean --deckname deck.korean --from-lang eng --to-lang kor --no-pronunciation`
raise "can't build deck" if File.read('deck.korean/deck.korean.txt').split("\n").count != 5
