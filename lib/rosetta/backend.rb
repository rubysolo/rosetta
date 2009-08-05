module I18n
  module Backend
    class Rosetta < Simple
      protected

      def init_translations
        load_translations(*I18n.load_path)
        load_database_translations
        @initialized = true
      end

      def load_database_translations
        translations.keys.each do |locale_code|
          locale = Locale.find_by_code(locale_code.to_s) rescue nil
          next unless locale

          locale.translations.each do |tr|

            next if tr.text.blank?

            data = { tr.key.to_sym => tr.text }

            ns = tr.translated_string.namespace
            data = ns.split(/\./).reject{|segment| segment.blank? }.reverse.inject(data) do |hash, element|
              { element.to_sym => hash }
            end unless ns.blank?

            merge_translations(locale_code, data)
          end
        end
      end
    end
  end
end