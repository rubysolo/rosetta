class TranslatedString < ActiveRecord::Base
  set_table_name "i18n_translated_strings"
  has_many :translations, :foreign_key => "i18n_translated_string_id"

  before_validation :set_defaults
  validates_presence_of :key

  def self.[](key)
    segments = key.split(/\./)
    db_key = segments.pop
    db_ns  = segments.compact.join('.')

    find_by_namespace_and_key(db_ns, db_key)
  end

  def key
    [self[:namespace], self[:key]].reject{|x| x.blank? }.join('.')
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
         ORDER BY namespace, key
      }, locale.id, Locale.main.id],
      :page => options[:page], :per_page => options[:per_page]
    )
  end

  private

  def set_defaults
    self.namespace = (self[:namespace] || "").split(/\./) + (self[:key] || "").split(/\./)
    self.key       = namespace.pop
    self.namespace = namespace.compact.join('.')
  end
end
