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
                 service_statuses: {
                    type: :array,
                    required: true,
                    items: { '$ref' => '#/components/schemas/service_status' }
                 },
                 order_ids: {
                    type: :array,
                    required: true,
                    items: { type: :integer }
                 }
               }
        run_test! do |response|
          expected = <<~JSON
            {
              "order_ids": [1],
              "service_statuses": [
                {
                  "info": {
                    "database": "app_test",
                    "host": "127.0.0.1",
                    "username": "app"
                  },
                  "name": "db",
                  "status": true,
                  "type": "db"
                }
              ]
            }
          JSON
          expect(response.body).to be_json_eql(expected).excluding('time')
        end
      end
    end
  end
end
