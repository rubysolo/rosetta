require File.join(File.dirname(__FILE__) + "/test_helper")
require 'action_controller'
require 'action_view/test_case'

class ViewTest < ActionView::TestCase
  def setup
    reset_db! && load_fixtures
  end

  test "custom missing translation wrapper" do
    assert_equal %q{<span class="missing_base_translation" id="missing_translation-en-missing">missing</span>}, translate('missing')
  end

  test "missing alternate translation should display default locale translation wrapped in missing translation span" do
    [:de, :it].each do |locale|
      I18n.locale = locale
      assert_equal %Q{<span class="missing_translation" id="missing_translation-#{locale}-db.namespace.test">Namespaced Lookup</span>}, translate('db.namespace.test')
      I18n.locale = :en
      assert_equal %Q{<span class="missing_translation" id="missing_translation-#{locale}-db.namespace.test">Namespaced Lookup</span>}, translate('db.namespace.test', :locale => locale)
    end
  end

  test "should be able to specify display without wrapper" do
    assert_equal %Q{Namespaced Lookup}, translate('db.namespace.test', :no_wrapper => true)
  end
end