class RosettaModelMigrationGenerator < Rails::Generator::NamedBase
  attr_accessor :migration_class_name, :translated_model, :migrate_data_for_columns

  def manifest
    record do |m|
      @migration_class_name = "Create#{class_name}Translations"
      @translated_model = class_name.constantize

      existing_columns = @translated_model.columns.map{|c| c.name.to_sym }
      @migrate_data_for_columns = @translated_model.translated_attributes.inject({}) do |h, (type, columns)|
        h[type] = columns.select{|c| existing_columns.include?(c) }
        h
      end.reject{|k,v| v.empty? }

      unless options[:command] == :destroy || @migrate_data_for_columns.empty?
        puts <<-__END_WARNING__
  ###
  ### WARNING
  ###

  Rosetta has generated a migration to move existing data to the #{ singular_name }_translations table.
  Make sure you have a database backup before proceeding, as the translated columns will be removed
  from the #{ plural_name } table.  You have been warned.

        __END_WARNING__
      end

      m.migration_template 'migration.erb', 'db/migrate', :migration_file_name => @migration_class_name.underscore
    end
  end
end
