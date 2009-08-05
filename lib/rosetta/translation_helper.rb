module ActionView
  module Helpers
    module TranslationHelper

      # override ActionView's default translate method
      def translate(key, options = {})
        options[:raise] = true
        content = I18n.translate(scope_key_by_partial(key), options)
        return content if options[:no_wrapper]

        if l = options[:original_locale]
          missing_translation(content, l, key)
        else
          content
        end
      rescue I18n::MissingTranslationData => e
        is_default_locale = e.locale == I18n.default_locale
        unless is_default_locale
          options[:locale]   = I18n.default_locale
          options[:original_locale] = e.locale
          retry
        end

        content = (key || "").split(/\./).last
        options[:no_wrapper] ? content : missing_translation(content, e.locale, key)
      end
      alias :t :translate

      def missing_translation(display, locale, key)
        span_options = {}
        span_options[:class] = locale.to_sym == I18n.default_locale ? "missing_base_translation" : "missing_translation"
        span_options[:id]    = "missing_translation-#{locale}-#{key}"
        content_tag('span', display, span_options)
      end
    end
  end
end
