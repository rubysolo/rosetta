class Locale < ActiveRecord::Base
  set_table_name "i18n_locales"
  has_many :translations, :foreign_key => "i18n_locale_id", :include => :translated_string

  validates_presence_of :name, :code

  def self.current
    find_by_code(I18n.locale.to_s)
  end

  def main?
    main
  end

  def self.main
    find_by_main(true)
  end
end