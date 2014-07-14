require "httparty"

module Glosbe
  class Translate
    include HTTParty
    base_uri("http://glosbe.com/gapi/")
    default_params('format': 'json')
    
    def self.Exception(*names)
      cl = Module === self ? self : Object
      names.each {|n| cl.const_set(n, Class.new(Exception))}
    end
    
    Exception :TranslateServerIsDown, :InvalidResponse,
              :MissingFromLanguage, :MissingToLanguage, :MissingPhraseLanguage 
    
    def self.translate(text, params={})
      raise(MissingFromLanguage) if not params[:from].nil?
      raise(MissingToLanguage) if not params[:to].nil?
      raise(MissingPhraseLanguage) if not params[:phrase.nil?

      params[:format] = 'json'

      response = self.class.get('/translate', params)
      puts response
      response = (response && response.parsed_response) ? response.parsed_response : nil
      puts response

      raise(TranslateServerIsDown) if (!response || response.empty?)
      raise(InvalidResponse, response["SearchResponse"]) if not response["SearchResponse"]['Translation']['Results'][0]['TranslatedTerm']

      return to_text
    end
    
  end
end