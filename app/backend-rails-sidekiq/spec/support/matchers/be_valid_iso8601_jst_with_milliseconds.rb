RSpec::Matchers.define :be_valid_iso8601_jst_with_milliseconds do
  match do |actual|
    begin
      # ISO 8601形式(ミリ秒まで)の正規表現
      # 例: 2024-01-01T12:34:56.789+09:00
      iso8601_regex = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}\+09:00\z/
      actual.is_a?(String) && iso8601_regex.match?(actual) && DateTime.iso8601(actual) && true
    rescue ArgumentError
      false
    end
  end

  failure_message do |actual|
    "#{actual} の形式は %Y-%m-%dT%H:%M:%S.%L+09:00 である必要があります(Time.iso8601でもパース成功する必要があります)"
  end
end
