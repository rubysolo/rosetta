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

            data = tr.key.split(/\./).reject{|segment| segment.blank? }.reverse.inject(tr.text) do |hash, segment|
              { segment.to_sym => hash }
            end

            merge_translations(locale_code, data)
          end
        end
      end
    end
  end
end