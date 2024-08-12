# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ISO8601JSTWithMillisecondsHelper' do
  it '通る' do
    expect("2024-01-01T12:34:56.789+09:00").to be_valid_iso8601_jst_with_milliseconds
  end

  it '通らない' do
    expect('invalid').not_to be_valid_iso8601_jst_with_milliseconds
  end

  it '閏年であれば、2月29日を指定している場合は通る' do
    expect("2024-02-29T12:34:60.789+09:00").to be_valid_iso8601_jst_with_milliseconds
  end

  it '閏年ではないのに、2月29日を指定している場合は通らない' do
    expect("2023-02-29T12:34:60.789+09:00").not_to be_valid_iso8601_jst_with_milliseconds
  end
end
