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

require_relative 'core_module'

module Pixmory
  class Pic < CoreModule
    attr_accessor :word

    def initialize(deckname, word, lang)
      @deck = deckname
      @word = word.split('/').first.strip
      @lang = lang
    end

    def to_s
      %Q{<img src="#{filename}" width="30%">}
    end

    def save
      target = "#{@deck}/#{@deck}.media/#{filename}"
      if url = gi_url(@word)
        save_url(target, url)
      end
    end

    private
    def filename
      "pixmory-#{@deck}-#{CGI::escape(@word)}.jpg"
    end

    def gi_url(word)
      pics = Google::Search::Image.new(:query => word, :language => @lang[0..1],
                                       :image_size => :huge, :type => :photo,
                                      :safety_level => :high)
                                 .first(10).map(&:uri)
      pics.map do |pic|
        uri = begin
                URI(pic)
              rescue URI::InvalidURIError
                next
              end
        response = begin
          Net::HTTP.start(uri.host, 80) do |http|
              http.request_head uri.path
          end
        rescue Timeout::Error, Errno::ETIMEDOUT, SocketError
          next
        end
        return pic if response && response.code.to_i == 200
      end
      nil
    end

  end
end
