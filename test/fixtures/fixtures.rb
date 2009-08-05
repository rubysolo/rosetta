@english = Locale.create(:name => 'English', :code => 'en', :iso => 'en-US', :main => true)
@german  = Locale.create(:name => 'German',  :code => 'de', :iso => 'de-DE')
@italian = Locale.create(:name => 'Italian', :code => 'it', :iso => 'it-IT')

@greeting = TranslatedString.create(:key => 'greeting')
@namespace = TranslatedString.create(:key => 'test', :namespace => 'db.namespace')

@english_greeting = @english.translations.create(:translated_string => @greeting, :text => 'Greetings from the database!')
 @german_greeting =  @german.translations.create(:translated_string => @greeting, :text => 'Grüße aus der Datenbank!')

@namespaced_translation = @english.translations.create(:translated_string => @namespace, :text => 'Namespaced Lookup')