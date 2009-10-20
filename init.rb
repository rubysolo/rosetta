require 'rosetta'

I18n.backend = I18n::Backend::Rosetta.new
I18n.send :include, Rosetta::I18nExtensions
ActiveRecord::Base.send :include, Rosetta::ActiveRecord::Base
