# frozen_string_literal: true

require 'logger'
require_relative 'hana_db/version'
require_relative 'hana_db/connection'
require_relative 'hana_db/instance'

# Provides plain access to the SAP Hana database
module HanaDB
  DEFAULTS = {
    logger: Logger.new(STDOUT)
  }.freeze

  class << self
    def prepare(options)
      options = DEFAULTS.merge(options)
      block_given? ? Instance.new(options, &Proc.new) : Instance.new(options)
    end
  end
end
