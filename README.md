Glosbe
======

Ruby Client for the Glosbe Api
http://glosbe.com/a-api

Example Usage
======
Glosbe can currently translated and provide definitons for words in both the target and source language

with rails add this to your Gemfile
    
    gem 'glosbe', '~> 0.0.9'

Examples with both provided methods

    require 'glosbe'
  
    translator = Glosbe::Translate.new('spa', 'eng')
    translator.translate('empezar')
    #=> "start"
    
    translator.translate_and_definition('empezar')
    #=> {:target_definitions=>["to set in motion", "to begin", "To begin an activity.", "To start, to initiate or take the first step into something.", "To begin an activity."], :source_definitions=>["Iniciar una actividad.", "Iniciar una actividad."], :translated=>"start"}
    

Glosbe requires passing the 3 letter ISO code for the target and source languages a list of these can be found here http://en.wikipedia.org/wiki/List_of_ISO_639-3_codes
