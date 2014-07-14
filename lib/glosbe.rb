require "httparty"

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
              :MissingFromLanguage, :MissingPhraseLanguage 
    
    def translate(phrase)
      translate_and_definition(phrase)[:translated]
    end

    def translate_and_definition(phrase)
      raise(MissingPhraseLanguage) if phrase.nil?
      @options[:query][:phrase] = phrase

      response = self.class.get('/translate', @options)
      response = (response && response.parsed_response) ? response.parsed_response : nil

      raise(TranslateServerIsDown) if (!response || response.empty?)
      raise(InvalidResponse) if response['tuc'].count < 1
      first_tuc = response['tuc'][0]
      meanings = first_tuc['meanings']
      target_definitions = []
      source_definitions = []

      meanings.each do |meaning|
        if meaning['language'] == @options[:query][:dest]
          target_definitions << meaning['text']
        else
          source_definitions << meaning['text']
        end
      end

      {target_definitions: target_definitions, source_definitions: source_definitions, translated: first_tuc['phrase']['text']}
    end
    
  end
end