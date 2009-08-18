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

          attributes.each do |a|
            if a.is_a?(Hash)
              a.each{|name,type| translates_attribute(name, type) }
            else
              translates_attribute(a, :string)
            end
          end

          self.send(:include, TranslatedModel)
        end

        def translates_attribute(attribute, type)
          self.translated_attributes[type] ||= []
          self.translated_attributes[type] << attribute
        end
      end
    end
  end
end

Rosetta::ActiveRecord.translated_models = []