### Pixmory

## Requirements
* Ruby >= 2.0
* Mecab (Optional: For Japanese furigana support. Should be in your package manager)

## Installation
    git clone https://github.com/pcboy/pixmory
    cd pixmory && bundle install

## Usage

For fabulous anki decks

    pcboy@home pixmory % bundle exec ruby pixmory.rb -h
    Options:
       --wordfile, -w <s>:   File containing words and their translation comma separated
       --deckname, -d <s>:   Name of the deck you want to create
       --from-lang, -f <s>:  Source language in the wordfile(e.g kor,eng, https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes)
       --to-lang, -t <s>:    Destination language in the wordfile(e.g eng, https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes)
       --help, -h:           Show this message

For basic translation before building a beautiful deck

    pcboy@home pixmory % bundle exec ruby translate.rb -h 
    Options:
        --wordfile, -w <s>:   File containing comma separated words to translate.
        --from-lang, -f <s>:  Source language in the wordfile(e.g ko,en, https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
        --to-lang, -t <s>:    Destination language(e.g en,ko https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
        --output, -o <s>:     Destination filename
        --help, -h:           Show this message


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

