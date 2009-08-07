@english = Locale.create(:name => 'English', :code => 'en', :iso => 'en-US', :main => true)
@german  = Locale.create(:name => 'German',  :code => 'de', :iso => 'de-DE')
@italian = Locale.create(:name => 'Italian', :code => 'it', :iso => 'it-IT')

@greeting = TranslatedString.create(:key => 'greeting')
@ns_test  = TranslatedString.create(:key => 'test', :namespace => 'db.namespace')
@ns_hello = TranslatedString.create(:key => 'db.namespace.hello')

@english.translations.create(:translated_string => @greeting, :text => 'Greetings from the database!')
@german.translations.create(:translated_string => @greeting, :text => 'Grüße aus der Datenbank!')

@english.translations.create(:translated_string => @ns_test, :text => 'Namespaced Lookup')
@english.translations.create(:translated_string => @ns_hello, :text => 'Hello!')