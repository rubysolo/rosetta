class RosettaMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.erb', 'db/migrate', :migration_file_name => "create_rosetta_translation_tables"
    end
  end
end
