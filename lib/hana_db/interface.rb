# frozen_string_literal: true

module HanaDB
  # Adds selection methods to database connection
  class Interface < SimpleDelegator
    def initialize(conn:)
      super(conn)
    end

    def select_one(sql, *args)
      select(sql, *args, &:fetch_hash)
    end

    def select_each(sql, *args)
      select(sql, *args) do |stmt|
        while (row = stmt.fetch_hash)
          yield row
        end
      end
    end

    def select_all(sql, *args)
      rows = []
      select_each(sql, *args) do |row|
        rows << row
      end
      rows
    end
  end
end
