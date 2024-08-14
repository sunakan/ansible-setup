class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def as_json(options = {})
    super(options).tap do |hash|
      # 全てのTime型, TimeWithZone型はJST変換で、milliseconds まで表現したISO8601形式に変換する
      # 例: "2024-01-01T12:34:56.789+09:00"
      attributes.filter { |_, v| v.is_a?(Time) || v.is_a?(ActiveSupport::TimeWithZone) }.each do |key, value|
        hash[key] = value.in_time_zone("Tokyo").iso8601(3) if hash.has_key?(key)
      end
    end
  end
end
