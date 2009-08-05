class TranslatedString < ActiveRecord::Base
  set_table_name "i18n_translated_strings"
  has_many :translations, :foreign_key => "i18n_translated_string_id"

  before_validation_on_create :set_defaults
  validates_presence_of :key

  def namespaced_key
    [namespace, key].reject{|x| x.blank? }.join('.')
  end

  def self.translations_for_locale(locale, options={})
    filter_sql = case options[:filter]
    when /missing/i
      "t.id IS NULL"
    when /outdated/i
      "t.updated_at < b.updated_at"
    else
      "(1=1)"
    end

    paginate_by_sql([%Q{
        SELECT s.*,
               t.id AS translation_id, t.text AS translation, t.updated_at AS translated_at,
               b.text AS base_translation, b.updated_at AS base_translated_at
          FROM i18n_translated_strings s
               LEFT JOIN i18n_translations t ON t.i18n_translated_string_id = s.id
                         AND t.i18n_locale_id = ?
               LEFT JOIN i18n_translations b ON b.i18n_translated_string_id = s.id
                         AND b.i18n_locale_id = ?
         WHERE #{filter_sql}
      }, locale.id, Locale.main.id],
      :page => options[:page], :per_page => options[:per_page]
    )
  end

  private

  def set_defaults
    self.namespace = (namespace || "").split(/\./) + (key || "").split(/\./)
    self.key       = namespace.pop
    self.namespace = namespace.compact.join('.')
  end
end