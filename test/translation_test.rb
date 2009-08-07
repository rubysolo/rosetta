require File.join(File.dirname(__FILE__) + "/test_helper")

class TranslationTest < ActiveSupport::TestCase
  test "stock I18n translation from locale files should still work" do
    assert_equal 'Hello world', I18n.translate('hello')
    assert_equal 'Guten tag',   I18n.translate("hello", :locale => :de)
  end

  test "key, namespace equivalence in stock I18n translation" do
    assert_equal 'Go', I18n.translate("one.two.three")
    assert_equal 'Go', I18n.translate("three", :scope => "one.two")
    assert_equal 'Go', I18n.translate("three", :scope => [:one, :two])
  end

  test "I18n translation from database storage" do
    assert_equal "Greetings from the database!", I18n.translate("greeting")
    assert_equal "Grüße aus der Datenbank!",     I18n.translate("greeting", :locale => :de)
  end

  test "key, namespace equivalence in database-stored translations" do
    assert_equal 'Namespaced Lookup', I18n.translate("db.namespace.test")
    assert_equal 'Namespaced Lookup', I18n.translate("test", :scope => "db.namespace")
    assert_equal 'Namespaced Lookup', I18n.translate("test", :scope => [:db, :namespace])

    assert_equal 'Hello!', I18n.translate("db.namespace.hello")
    assert_equal 'Hello!', I18n.translate("hello", :scope => "db.namespace")
    assert_equal 'Hello!', I18n.translate("hello", :scope => [:db, :namespace])
  end
end
