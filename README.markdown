Rosetta
=======

*as it turns out, databases are excellent repositories for data!*

Rosetta is a Rails i18n plugin that extends the Rails 2 i18n API to:

* store translation data in the database
* fallback to the base translation if the locale-specific translation is missing
* provide translation support for model attributes

Here's a quick feature overview:

### Database storage of translations

I like YAML as much as the next guy, but the odds are, your app has a database available where you could be storing the translations instead.  Once database storage is enabled, it becomes Rails-style simple to add translation management functionality to your app through the UI, so if you're lucky enough to delegate the actual translation task, your translators can enter and update translations directly.  Rosetta provides database storage for translations and merges the database-stored translations with the YAML-stored translations at boot time (or each page load in the development environment), so if you're already using i18n, you can gradually migrate your translations to the DB.

Rosetta provides a `Locale` model, which stores all available locales for your app.  `Locale.current` and `Locale.main` do pretty much what you would expect.  The `TranslatedString` model represents a block of text from your views that has been marked as translatable (using the standard Rails `translate` or `t` helper method).  Following best practices, you probably want to set up your `TranslatedString` keys with namespaces so that you can keep them somewhat organized.  For example, you might have a key of "pages.home.title" for the `TranslatedString` in the top header of the homepage; Rosetta will take care of splitting it up into "pages.home" as the namespace and "title" as the key.  `TranslatedString` includes a `translations_for_locale` class method to paginate through all translations (or missing or outdated translations) for a given locale -- handy for building the translation management UI (*NOTE:* this requires the `will_paginate` plugin/gem).  A `TranslatedString` has_many `Translation`s, each of which belongs to a `Locale`.  A translation also includes a convenience accessor for the base-language version, which can help the translators by displaying the base version as they create the alternate-language version.

### Fallback to base translation

It's a good thing for a translator to be able to browse the site and quickly identify blocks of text that still need to be translated.  It's a bad thing (IMHO) for your end users to quickly identify these missing translations.  Rosetta overrides the stock i18n ActionView `translate` method to fall back to the base translation but wrap the text in a CSS-classed span in the event of a missing translation.  You can have your cake and eat it too -- by conditionally including some CSS for logged-in translators, you can make the missing blocks stand out (or even [blink](http://www.domedia.org/oveklykken/css-blinking-text.php) if you're that churlish), but be less conspicuous for your end users.  The Rosetta ActionView `translate` helper retains the stock Rails functionality of scoping leading-dot keys with the path to the current partial.

### Model translations

Translating view text is only half the battle -- you probably have some data already stored in your database that you will need to translate.  Rosetta makes this as simple as adding a `translates` directive to your model, then continuing to use your accessor methods as you already are -- current locale will be taken into consideration when reading/writing translated attributes.  Each model with translated attributes will get a translations table (migration generator is included) to store its translated attributes.  To facilitate the (admittedly edge) case of changing base translations, all translations--including the base--are stored in the external table.

Getting Started
===============

1. Install the plugin

        script/plugin install http://github.com/rubysolo/rosetta

2. Generate and run the migration to create the translation tables

        script/generate rosetta_migration
        rake db:migrate

3. Populate your tables with locales, translated strings, and translations

        @en = Locale.create(:code => "en", :name => 'English', :main => true)
        @de = Locale.create(:code => "de", :name => 'German')

        @title = TranslatedString.create(:key => "pages.home.title")

        @title.translations.create(:locale => @en, :text => "Welcome")
        @title.translations.create(:locale => @de, :text => "Wilkommen")Rosetta

4. Set up your models for translation

        class Post < ActiveRecord::Base
          translates :title, :body => :text     # <------ Add this line
        end


        script/generate rosetta_model_migration Post

5. (optional) Create administration pages for your translation data

What Next?
==========

Give it a whirl.  Submit bug reports / feature requests to the [issue tracker](http://github.com/rubysolo/rosetta/issues)  Or fork away and add features!

License
=======

(The MIT License)

Copyright © 2008-2009 Solomon White

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
