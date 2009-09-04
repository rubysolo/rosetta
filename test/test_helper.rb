require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'mocha'
require 'ruby-debug'

PLUGIN_ROOT = File.expand_path(File.dirname(__FILE__) + '/..')
$LOAD_PATH << PLUGIN_ROOT + '/lib'

require 'init'

locale_path = "#{PLUGIN_ROOT}/test/fixtures/locales"
Dir["#{locale_path}/*.yml"].each { |locale| I18n.load_path << locale }
I18n.reload!

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Base.logger = Logger.new("/dev/null")

class ActiveSupport::TestCase
  def reset_db!( schema_file = "#{PLUGIN_ROOT}/test/fixtures/schema.rb" )
    ::ActiveRecord::Migration.verbose = false   # Quiet down the migration engine
    ::ActiveRecord::Base.establish_connection({
      :adapter => 'sqlite3',
      :database => ':memory:'
    })
    ::ActiveRecord::Base.silence do
      load schema_file
    end
  end

  def load_fixtures( fixture_file = "#{PLUGIN_ROOT}/test/fixtures/fixtures.rb")
    load fixture_file
    I18n.reload!
  end

  def setup
    reset_db! && load_fixtures
  end

  def teardown
    I18n.locale = I18n.default_locale
  end
end
