require 'swagger_helper'

RSpec.describe 'welcome', type: :request do
  path '/' do
    get('show welcome') do
      # consumes: リクエストのコンテンツタイプ
      # produces: レスポンスのコンテンツタイプ
      # response: 予想されるレスポンス
      #   schema: スキーマ
      #     parameters: 入力パラメータ
      consumes 'application/json'
      produces 'application/json'
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 list: { type: :array, items: { type: :string } },
                 time: {
                   type: :string,
                   example: '2024-01-01T12:34:56.789+09:00'
                 }
               },
               required: %w[message list time]
        run_test! do |response|
          expected = {
            message: 'Welcome to the API',
            list: %w[a b]
          }.to_json
          expect(response.body).to be_json_eql(expected).excluding('time')
          expect(JSON.parse(response.body)['time']).to be_valid_iso8601_jst_with_milliseconds
        end
      end
    end
  end
end
