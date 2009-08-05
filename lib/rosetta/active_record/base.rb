module Rosetta
  module ActiveRecord
    mattr_accessor :translated_models

    # included into ActiveRecord::Base to add #translate class method
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def translates(*attributes)
          cattr_accessor :translated_attributes
          cattr_accessor :translations_class

          self.translated_attributes = {}

          attributes.each { |a| translates_attribute(a) }

          self.send(:include, TranslatedModel)
        end

        def translates_attribute(attribute_or_hash)
          attribute, type = attribute_or_hash.is_a?(Symbol) ? [attribute_or_hash, :string] : attribute_or_hash.to_a.first

          self.translated_attributes[type] ||= []
          self.translated_attributes[type] << attribute
        end
      end
    end
  end
end

Rosetta::ActiveRecord.translated_models = []