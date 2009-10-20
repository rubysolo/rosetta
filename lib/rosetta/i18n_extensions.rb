module Rosetta
  module I18nExtensions
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # temporarily override the active locale
      def with(locale)
        active_locale = I18n.locale
        I18n.locale = locale
        yield
        I18n.locale = active_locale
      end
    end
  end
end