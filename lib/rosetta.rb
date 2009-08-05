require 'activesupport' unless defined? ActiveSupport
require 'activerecord'  unless defined? ActiveRecord
require 'action_view'   unless defined? ActionView
require 'action_view/base'

Dir[File.dirname(__FILE__) + '/models/*.rb'].each{|f| require f }

require 'rosetta/backend'
require 'rosetta/translation_helper'
require 'rosetta/active_record/base'
require 'rosetta/active_record/translated_model'