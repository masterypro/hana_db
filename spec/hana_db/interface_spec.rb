# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe HanaDB::Interface do
  subject(:interface) { described_class.new(conn: conn) }

  let(:stmt_class) do
    Struct.new(:data) do
      def fetch_hash
        data.shift
      end
    end
  end

  let(:conn_class) do
    Struct.new(:stmt) do
      def select(_sql, *_args)
        yield(stmt)
      end
    end
  end

  let(:data) { [1, 2, 3, 4, 5] }
  let(:conn) { conn_class.new(stmt_class.new(data.clone)) }

  describe '#select_all' do
    it do
      expect(interface.select_all(nil)).to eq(data)
    end
  end

  describe '#select_each' do
    it do
      expect { |b| interface.select_each(nil, &b) }.to(
        yield_successive_args(*data)
      )
    end
  end

  describe '#select_one' do
    it do
      expect(interface.select_one(nil)).to eq(data.first)
    end
  end
end
# rubocop:enable Metrics/BlockLength
