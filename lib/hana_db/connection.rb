# frozen_string_literal: true

require 'odbc_utf8'

module HanaDB
  # ODBC database connection
  class Connection
    class Error < StandardError; end
    class ConnectionClosed < Error; end

    DEFAULTS = {
      use_time: true,
      use_utc: true
    }.freeze

    def initialize(options)
      @options = DEFAULTS.merge(options)

      open
    end

    def open
      return if active?

      catch_odbc_error do
        logger.info("Open connection \"#{@options.fetch(:dsn)}\"")
        @odbc = ODBC.connect(@options.fetch(:dsn),
                             @options.fetch(:username),
                             @options.fetch(:password))
        @odbc.use_time = @options.fetch(:use_time)
        @odbc.use_utc = @options.fetch(:use_utc)
      end
    end

    def close
      return unless active?

      catch_odbc_error do
        logger.info("Close connection \"#{@options.fetch(:dsn)}\"")
        @odbc.disconnect
        @odbc = nil
      end
    end

    def active?
      !@odbc.nil?
    end

    def select(sql, *args)
      raise ConnectionClosed unless active?

      catch_odbc_error do
        logger.debug("Query: #{sql} with args #{args}")
        stmt = @odbc.run(sql, *args)
        result = yield stmt
        stmt.drop
        result
      end
    end

    private

    def logger
      @options.fetch(:logger)
    end

    def catch_odbc_error
      yield
    rescue ODBC::Error => e
      raise Error, e.message
    end
  end
end
