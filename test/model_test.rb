require File.join(File.dirname(__FILE__) + "/test_helper")

class ModelTest < ActiveSupport::TestCase
  def setup
    reset_db! && load_fixtures
    I18n.translate('anything.to.populate.translation.cache')

    @english = Locale.find_by_code 'en'
    @new_string = TranslatedString.create!(:key => 'test.namespaced.translation')
    @new_string.reload
  end

  test "locale model should be defined" do
    assert Locale.respond_to?(:find)
  end

  test "finding main locale" do
    assert_equal 'en', I18n.locale.to_s
    assert_equal @english, Locale.main
  end

  test "locale translations relationship should be defined" do
    assert @english.respond_to?(:translations)
    assert ! @english.translations.empty?
  end

  test "creating a new translated string should extract namespace from key" do
    assert_equal 'translation', @new_string[:key]
    assert_equal 'test.namespaced', @new_string.namespace
    assert_equal 'test.namespaced.translation', @new_string.key
  end

  test "new translations require a reload before becoming active" do
    @english.translations.create!(:translated_string => @new_string, :text => "This is a test")
    assert_not_equal 'This is a test', I18n.translate('test.namespaced.translation')
    I18n.reload!
    assert_equal 'This is a test', I18n.translate('test.namespaced.translation')
  end

  test "for_locale named scope" do
    @english.translations.create!(:translated_string => @new_string, :text => "This is a test")
    assert ! @new_string.translations.for_locale(:en).empty?
    assert ! @new_string.translations.for_locale(@english).empty?
  end

  test "base_translation accessor" do
    @string = TranslatedString.find_by_key 'greeting'
    @en = @string.translations.for_locale(:en).first
    @de = @string.translations.for_locale(:de).first

    assert_equal @en, @de.base_translation
  end
end
