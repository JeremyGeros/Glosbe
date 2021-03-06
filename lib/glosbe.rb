require "httparty"
require "htmlentities"

module Glosbe
  class Translate
    include HTTParty
    base_uri 'glosbe.com/gapi'
    default_params format: 'json'

    def initialize(from, dest='eng')
      raise(MissingFromLanguage) if from.nil?
      @options = { query: {from: from, dest: dest }}
    end
    
    def self.Exception(*names)
      cl = Module === self ? self : Object
      names.each {|n| cl.const_set(n, Class.new(Exception))}
    end
    
    Exception :TranslateServerIsDown, :InvalidResponse,
              :MissingFromLanguage, :MissingPhraseLanguage, :IPBlocked
    
    def translate(phrase)
      translate_and_definition(phrase)[:translated]
    end

    def translate_and_definition(phrase)
      raise(MissingPhraseLanguage) if phrase.nil?
      @options[:query][:phrase] = phrase

      response = self.class.get('/translate', @options)
      response = (response && response.parsed_response) ? response.parsed_response : nil

      raise(TranslateServerIsDown) if (!response || response.empty?)
      raise(IPBlocked) if (response['message'] && response['message'] == 'Too many queries, your IP has been blocked')

      target_definitions = []
      source_definitions = []
      translated = (response['tuc'] && response['tuc'].first && response['tuc'].first['phrase']) ? response['tuc'].first['phrase']['text'] : nil
      coder = HTMLEntities.new
      response['tuc'].each do |translation_block|
        next if translation_block['meanings'].nil? || translation_block['authors'].include?(1)
        translation_block['meanings'].each do |meaning|
          if meaning['language'] == @options[:query][:dest]
            target_definitions << coder.decode(meaning['text'])
          else
            source_definitions << coder.decode(meaning['text'])
          end
        end
      end

      {target_definitions: target_definitions, source_definitions: source_definitions, translated: translated}
    end
    
  end
end