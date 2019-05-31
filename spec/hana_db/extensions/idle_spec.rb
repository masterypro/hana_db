# frozen_string_literal: true

require 'spec_helper'
require 'hana_db/extensions/idle'

# rubocop:disable Metrics/BlockLength
RSpec.describe HanaDB::Extensions::IDLE do
  subject(:conn) { described_class.new(conn: conn_class.new, timeout: timeout) }

  let(:timeout) { 2 }

  let(:conn_class) do
    Class.new do
      attr_reader :open_len, :close_len

      def initialize
        @open_len = 0
        @close_len = 0
      end

      def open
        @open_len += 1
      end

      def close
        @close_len += 1
      end

      def select(_sql, *_args)
        yield nil
      end
    end
  end

  describe '#select' do
    context 'when time is over' do
      it do
        aggregate_failures do
          conn.select(nil) { |_stmt| }
          expect(conn.open_len).to eq(0)
          expect(conn.close_len).to eq(0)

          sleep(1)

          conn.select(nil) { |_stmt| }
          expect(conn.open_len).to eq(0)
          expect(conn.close_len).to eq(0)
        end
      end
    end

    context "when time isn't over" do
      it do
        aggregate_failures do
          conn.select(nil) { |_stmt| }
          expect(conn.open_len).to eq(0)
          expect(conn.close_len).to eq(0)

          sleep(2)

          conn.select(nil) { |_stmt| }
          expect(conn.open_len).to eq(1)
          expect(conn.close_len).to eq(1)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
