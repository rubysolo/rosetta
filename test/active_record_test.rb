require File.join(File.dirname(__FILE__) + "/test_helper")

class ActiveRecordTest < ActiveSupport::TestCase

  class Post < ActiveRecord::Base
    translates :title, :body => :text
  end

  test "translated models are enumerated" do
    assert_equal ['Post'], Rosetta::ActiveRecord.translated_models
  end

  test "translated attributes are tracked by type" do
    assert_equal %w[ string text ], Post.translated_attributes.keys.map(&:to_s).sort
    assert_equal [:body], Post.translated_attributes[:text]
    assert_equal [:title], Post.translated_attributes[:string]
  end

  test "translations table management" do
    assert_nothing_raised {
      assert ! ActiveRecord::Base.connection.table_exists?("post_translations")
      Post.create_translations_table!
      assert ActiveRecord::Base.connection.table_exists?("post_translations")
      Post.drop_translations_table!
      assert ! ActiveRecord::Base.connection.table_exists?("post_translations")
    }
  end

  test "translated attributes stored in parallel" do
    assert_nothing_raised {
      Post.create_translations_table!

      assert_equal 0, PostTranslation.count
      assert PostTranslation.all.empty?

      I18n.locale = :en

      @post = Post.create(:title => "Hello", :body => "This is a post")
      assert_equal 1, PostTranslation.count

      I18n.locale = :de

      @post.title = "Hallo"
      @post.body = "Dies ist ein post"
      @post.save

      assert_equal 2, PostTranslation.count
    }
  end
end