module Rosetta
  module ActiveRecord
    # included into model to add translation functionality
    module TranslatedModel
      def self.included(base)
        base.send :extend, ClassMethods

        Rosetta::ActiveRecord.translated_models << base.class_name
        base.translations_class = "#{base.class_name}Translation"

        base.instance_eval do
          has_many :translations, :class_name => self.translations_class
          after_save :save_translation

          translated_attributes.values.flatten.each do |attribute_name|
            define_method :"#{attribute_name}" do
              current_translation.send :"#{attribute_name}"
            end

            define_method :"#{attribute_name}=" do |value|
              current_translation.send :"#{attribute_name}=", value
            end
          end
        end

        if !Object.const_defined?(base.translations_class)
          Object.const_set(base.translations_class, Class.new(::ActiveRecord::Base)).class_eval do
            belongs_to :"#{base.class_name.underscore}"
            belongs_to :locale, :foreign_key => "i18n_locale_id"

            named_scope :for_locale, lambda{|locale|
              locale = Locale.find_by_code!(locale) unless locale.is_a?(Locale)
              { :conditions => { :i18n_locale_id => locale.id }}
            }
          end
        end

        base.translations_class.constantize.instance_eval do
          define_method :item_id do
            self[:"#{base.class_name.underscore}_id"]
          end

          define_method :item_id= do |value|
            self[:"#{base.class_name.underscore}_id"] = value
          end

          define_method :base_translation do
            self.class.find :first, :conditions => {
              :"#{base.class_name.underscore}_id" => self[:"#{base.class_name.underscore}_id"],
              :i18n_locale_id => Locale.main.id
            }
          end
        end
      end

      module ClassMethods
        def create_translations_table!
          create_translations_table(true)
        end

        def create_translations_table(force=false)
          ::ActiveRecord::Base.connection.create_table translations_table, :force => force do |t|
            t.references :i18n_locale, table_name.singularize.to_sym
            translated_attributes.each do |type, attribute_names|
              t.send(type, *attribute_names)
            end
            t.timestamps
          end

          ::ActiveRecord::Base.connection.add_index translations_table, :i18n_locale_id
          ::ActiveRecord::Base.connection.add_index translations_table, :"#{table_name.singularize.to_sym}_id"
        end

        def drop_translations_table
          ::ActiveRecord::Base.connection.drop_table translations_table
        end
        alias :drop_translations_table! :drop_translations_table

        def translations_table
          @translations_table ||= translations_class.constantize.table_name
        end
      end

      # instance methods
      def current_translation
        @current_translation = nil if current_translation_stale?
        @current_translation ||= translations.for_locale(Locale.current).first || translations.new(:locale => Locale.current)
      end

      def current_translation_stale?
        @current_translation && @current_translation.locale.code.to_sym != I18n.locale.to_sym
      end

      private

      def save_translation
        returning true do
          if @current_translation.try(:changed?)
            @current_translation.item_id = self.id
            @current_translation.save
          end
        end
      end
    end
  end
end
