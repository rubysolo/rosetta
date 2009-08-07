class Translation < ActiveRecord::Base
  set_table_name "i18n_translations"
  belongs_to :locale, :foreign_key => "i18n_locale_id"
  belongs_to :translated_string, :foreign_key => "i18n_translated_string_id"

  delegate :key, :namespace, :namespaced_key, :to => :translated_string

  named_scope :for_locale, lambda{|locale|
    locale = Locale.find_by_code!(locale.to_s) unless locale.is_a?(Locale)
    { :conditions => { :i18n_locale_id => locale.id }}
  }

  before_save :trim_text
  validates_presence_of :i18n_locale_id, :i18n_translated_string_id

  def base_translation
    locale.main? ? self : translated_string.translations.find_by_i18n_locale_id(Locale.main.id)
  end

  private

  def trim_text
    self.text.strip! unless text.nil?
  end
end