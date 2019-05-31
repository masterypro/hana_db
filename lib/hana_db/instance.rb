# frozen_string_literal: true

require 'connection_pool'
require_relative 'connection'
require_relative 'interface'

module HanaDB
  # Database instance with connection pool
  class Instance
    DEFAULTS = {
      conn_pool: 1
    }.freeze

    def initialize(options)
      @options = DEFAULTS.merge(options)
      @extensions = {}

      instance_eval(&Proc.new) if block_given?
    end

    def connection
      @connection ||= begin
        ConnectionPool::Wrapper.new(size: @options.fetch(:conn_pool)) do
          build_connection
        end
      end
    end

    def close
      @connection&.pool_shutdown(&:close)
    end

    def use(klass, options)
      @extensions[klass] = options
    end

    private

    def build_connection
      conn = Connection.new(dsn: @options.fetch(:dsn),
                            username: @options.fetch(:username),
                            password: @options.fetch(:password),
                            logger: @options.fetch(:logger))
      @extensions.each do |klass, options|
        conn = klass.new(options.merge(conn: conn))
      end
      Interface.new(conn: conn)
    end
  end
end
