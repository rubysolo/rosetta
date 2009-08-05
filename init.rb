require 'rosetta'

I18n.backend = I18n::Backend::Rosetta.new
ActiveRecord::Base.send :include, Rosetta::ActiveRecord::Base
