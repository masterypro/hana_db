# frozen_string_literal: true

module HanaDB
  module Extensions
    # Reconnects to database after idle timeout
    class IDLE < SimpleDelegator
      def initialize(conn:, timeout:)
        @timeout = timeout

        super(conn)
      end

      def select(sql, *args)
        if !@last_usage_at.nil? && @last_usage_at + @timeout < Time.now
          close
          open
        end

        result = super(sql, *args)
        @last_usage_at = Time.now
        result
      end
    end
  end
end
