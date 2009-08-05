class RosettaModelMigrationGenerator < Rails::Generator::NamedBase
  attr_accessor :migration_class_name, :translated_model, :migrate_data_for_columns

  def manifest
    record do |m|
      @migration_class_name = "Create#{class_name}Translations"
      @translated_model = class_name.constantize

      existing_columns = @translated_model.columns.map{|c| c.name.to_s }
      @migrate_data_for_columns = @translated_model.translated_attributes.inject({}) do |h, (type, columns)|
        h[type] = columns.select{|c| existing_columns.include?(c) }
        h
      end.reject{|k,v| v.empty? }

      m.migration_template 'migration.erb', 'db/migrate', :migration_file_name => @migration_class_name.underscore
    end
  end
end
