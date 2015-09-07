# Pixmory

## Introduction

Pixmory is a language learning hack tool. Pixmory is the contraction of Pictures and Memory.  
As an avid user of [spaced repetition software](https://en.wikipedia.org/wiki/Spaced_repetition#Software),
I know how hard it is to make good decks. That's why I made pixmory.

Having a picture for each flashcard is incredibly helpful for memorization ([Picture Recognition improves with subsequent verbal information](http://www.arts.uwaterloo.ca/~cmacleod/Research/Articles/jepwiseman85.pdf), [Picture Superiority Effect](http://en.wikipedia.org/wiki/Picture_superiority_effect)).  
We also know that learning words in context is incredibly important.  
That's why pixmory is not only downloading pictures for your words but also adds a sentence for each flashcard (if possible).  
But that's not all. Pixmory also adds the pronounciation (when available) of the word on each flaschard!  
Finally, pixmory has furigana support when generating decks to Japanese language.

Pixmory is still in alpha stage, but usable right now.  
It's just the start. A full suite of tools is gonna come in a near future. =)


## Requirements
* Ruby >= 1.9
* Mecab (Optional: For Japanese furigana support. Should be in your package manager)
* A Wordreference API Key
* A forvo API Key

## Installation
    git clone https://github.com/pcboy/pixmory
    cd pixmory && bundle install

Register to http://api.forvo.com/ to get a Forvo API key (free account available).  
~~Go to the [Word reference API registration page](http://www.wordreference.com/docs/APIregistration.aspx) and get an API key (Totally free, thanks WR!)~~
Wordreference has no API anymore, we are using scraping now. So no API keys are needed.

When you have one put it inside config.rb:

``` ruby
    module Pixmory
      FORVO_API_KEY = ''
    end
```

## Usage

### For basic translation before building a beautiful deck

Pixmory includes a nice little tool to translate list of words to your target language using WordReference.

I'm including a sample\_words text file which contains 346 of the most used basic and useful words in english (lot of action words, colors, adjectives etc).
I'm also including a file called NAWL_sorted_by_SFI.txt, containing 963 of the most used words in english, sorted by frequency. (http://www.newacademicwordlist.org/ for more info).

    pcboy@home pixmory % bundle exec ruby translate.rb -h 
    Options:
        --wordfile, -w <s>:   File containing comma separated words to translate.
        --from-lang, -f <s>:  Source language in the wordfile(e.g ko,en, https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
        --to-lang, -t <s>:    Destination language(e.g en,ko https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
        --output, -o <s>:     Destination filename
        --help, -h:           Show this message

I wanted to translate this wordfile to korean, so I basically did:

    $> bundle exec ruby translate.rb --wordfile sample_words --from-lang en --to-lang ko -o translated_words.korean

Be careful, the language format is ISO-639-1, so the first *two* letters of the language should be used.

After a few minutes, each word is translated and the sample\_words.korean looks like that:

    to work, 일하다
    to play,놀다 /  놀이하다
    to go,가다
    to walk,걷다 /  걸어가다

Now that we have this awesome translated wordfile, we can go to the next step, creating a fabulous Anki deck.

### For fabulous anki decks
Pixmory can create anki decks looking like that:

![A typical pixmory generated card. English to Korean.](/img/deck.jpg "A typical pixmory generated card. English to Korean")

How?

    pcboy@home pixmory % bundle exec ruby pixmory.rb -h
    Options:
                         --wordfile, -w <s>:   File containing words and their translation comma separated
                         --deckname, -d <s>:   Name of the deck you want to create
                        --from-lang, -f <s>:   Source language in the wordfile(e.g kor,eng, https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes)
                          --to-lang, -t <s>:   Destination language in the wordfile(e.g eng, https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes)
    --pronunciation, --no-pronunciation, -p:   Use forvo.com pronunciations on cards (default: true)
              --pictures, --no-pictures, -i:   Show pictures on cards (default: true)
              --furigana, --no-furigana, -u:   Use furiganas on cards (only works with Japanese) (default: true)
              --sentence, --no-sentence, -s:   Show sample sentences on cards (default: true)
                                 --help, -h:   Show this message

Example:
    `$> bundle exec ruby pixmory.rb --wordfile translated_words --deckname deck.korean --from-lang eng --to-lang kor`

Be careful, the language format is ISO-639-2, so the first *three* letters of the language should be used.

After a few minutes in the deck.korean folder, you'll be able to find a few files:

    $> ls deck.korean
    deck.korean.media deck.korean.txt tmp

Now this is simple. You need to copy all the media files inside your own anki collection.
Usually that means a `cp -rf deck.korean.media/* ~/Anki/User\ 1/collection.media/`.
Next step is actually importing the deck.  
Open Anki, go to File, Import, choose the deck.korean.txt file, don't forget to tick the "Allow HTML in fields" option, and choose the destinaton deck.

That should work now!

## Notes
* Pixmory is not perfect. Be careful. I would say that 98% of the time this is really working well. But it can be messed up with homonyms for instance.
* The free Forvo API account authorizes a limited amount of connections each 24 hours. If you have a lot of words you may need to complete the pixmory deck generation process in multiple days. This is not a big problem, pixmory keeps track of which pronunciation has been downloaded or not. So just restart the script again, let it complete, and hopefully soon you'll have all the pronunciations you need.

## Thanks to
~~* [WordReference](http://wordreference.com) for their nice TOTALLY FREE Api.~~ Wordreference stopped their API sadly
* [Forvo](http://www.forvo.com) for their rich database of pronunciations and API.  
* ~~[Fotopedia](http://www.fotopedia.com) for their beautiful pictures~~ Fotopedia closed their service. =(
* Google image search
* All the open source stuff I used to build pixmory

## License
Pixmory is released under the [Do What The Fuck You Want To Public License](http://www.wtfpl.net/) by Sam Hocevar.

[![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-4.png)](http://www.wtfpl.net)

## Donating
In case you feel generous, here is a bitcoin address! :
[14TjdyiCuF22ikG3Rj5pwGj9X1x26PxkRN](https://blockchain.info/address/14TjdyiCuF22ikG3Rj5pwGj9X1x26PxkRN)

## Contributing!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
