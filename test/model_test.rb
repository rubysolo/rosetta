require File.join(File.dirname(__FILE__) + "/test_helper")

class ModelTest < ActiveSupport::TestCase
  def setup
    reset_db! && load_fixtures
    I18n.translate('anything.to.setup.translation.cache')

    @english = Locale.find_by_code 'en'
    @new_string = TranslatedString.create!(:key => 'test.namespaced.translation')
    @new_string.reload
  end

  test "locale model should be defined" do
    assert Locale.respond_to?(:find)
  end

  test "locale translations relationship should be defined" do
    assert @english.respond_to?(:translations)
    assert ! @english.translations.empty?
  end

  test "creating a new translated string should extract namespace from key" do
    assert_equal 'translation',     @new_string.key
    assert_equal 'test.namespaced', @new_string.namespace
  end

  test "new translations require a reload before becoming active" do
    @new = @english.translations.create(:translated_string => @new_string, :text => "This is a test")
    assert_not_equal 'This is a test', I18n.translate('test.namespaced.translation')
    I18n.reload!
    assert_equal 'This is a test', I18n.translate('test.namespaced.translation')
  end
end
