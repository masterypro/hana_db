# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe HanaDB do
  it 'has a version number' do
    expect(HanaDB::VERSION).not_to be nil
  end
end
