ActiveRecord::Schema.define(:version => 1) do
  create_table :i18n_locales, :force => true do |t|
    t.string :name, :code, :iso
    t.boolean :main, :default => false
    t.timestamps
  end

  create_table :i18n_translated_strings, :force => true do |t|
    t.string :namespace, :key
    t.timestamps
  end

  create_table :i18n_translations, :force => true do |t|
    t.references :i18n_locale, :i18n_translated_string
    t.text :text
    t.timestamps
  end

  create_table :posts, :force => true do |t|
    t.timestamps
  end
end