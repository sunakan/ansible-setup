# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      # OpenAPI上で再利用可能なコンポーネント
      # OpenAPIスキーマを利用してコード生成時に、モデルの生成にも利用される
      components: {
        schemas: {
          service_status: {
            description: 'サービスステータス(ServiceStatus)',
            type: :object,
            properties: {
              name: {
                type: :string,
                required: true,
                example: 'db',
                description: 'サービス名'
              },
              type: {
                type: :string,
                required: true,
                example: 'db',
                description: 'サービスの種類(db: データベース, api: API)'
              },
              status: {
                type: :boolean,
                required: true,
                example: true,
                description: 'サービスのステータス(true: 正常, false: 異常)'
              },
              info: {
                type: :object,
                additionalProperties: true,
                example: "{ database: 'app_test', host: '127.0.0.1', username: 'app' }",
                description: 'サービスの情報'
              }
            }
          },
          product: {
            description: '製品(Product)',
            type: :object,
            properties: {
              id: {
                type: :integer,
                required: true,
                example: 1,
                description: '製品ID(ユニーク)'
              },
              name: {
                type: :string,
                required: true,
                example: 'MacBook Pro(M4)',
                description: '製品名'
              },
              quantity_remaining: {
                type: :integer,
                required: true,
                example: 99,
                description: '在庫数',
                minimum: 0
              },
              price_cents: {
                type: :integer,
                required: true,
                example: 100,
                description: '価格(セント)',
                minimum: 0
              },
              created_at: {
                type: :string,
                required: true,
                example: '2024-01-01T23:59:59.123+09:00',
                description: 'レコード作成日時(メタデータ)',
                # ミリ秒が不要なら、'date-time' で良い
                pattern: '^((?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9][0-9][0-9])(Z|[+|-]([0-9][0-9]:[0-9][0-9]))$'
              },
              updated_at: {
                type: :string,
                required: true,
                example: '2024-01-01T23:59:59.123+09:00',
                description: 'レコード更新日時(メタデータ)',
                pattern: '^((?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9][0-9][0-9])(Z|[+|-]([0-9][0-9]:[0-9][0-9]))$'
              }
            }
          },
          order: {
            description: '注文(Order)',
            type: :object,
            properties: {
              id: {
                type: :integer,
                required: true,
                example: 1,
                description: '注文ID(ユニーク)'
              },
              product_id: {
                type: :integer,
                required: true,
                example: 321,
                description: '製品ID'
              },
              quantity: {
                type: :integer,
                required: true,
                example: 99,
                description: '数量',
                minimum: 1
              },
              address: {
                type: :string,
                required: true,
                example: '東京都港区芝公園4丁目2-8 東京タワー',
                description: '配達先の住所'
              },
              email: {
                type: :string,
                required: true,
                email: 'test@example.com',
                description: '連絡先メールアドレス'
              },
              created_at: {
                type: :string,
                required: true,
                example: '2024-01-01T23:59:59.123+09:00',
                description: 'レコード作成日時(メタデータ)',
                # ミリ秒が不要なら、'date-time' で良い
                pattern: '^((?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9][0-9][0-9])(Z|[+|-]([0-9][0-9]:[0-9][0-9]))$'
              },
              updated_at: {
                type: :string,
                required: true,
                example: '2024-01-01T23:59:59.123+09:00',
                description: 'レコード更新日時(メタデータ)',
                pattern: '^((?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9][0-9][0-9])(Z|[+|-]([0-9][0-9]:[0-9][0-9]))$'
              },
              user_id: {
                type: :integer,
                required: true,
                example: 123,
                description: 'ユーザID'
              },
              charge_completed_at: {
                type: :string,
                nullable: true,
                required: true,
                example: '2024-01-01T23:59:59.123+09:00',
                description: '支払い完了日時',
                pattern: '^((?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9][0-9][0-9])[+|-]([0-9][0-9]:[0-9][0-9])$'
              },
              charge_successful: {
                type: :boolean,
                required: true,
                example: 'true',
                description: '支払いが成功したかどうか(true: 成功、false: 未支払い or 失敗)'
              },
              charge_decline_reason: {
                type: :string,
                nullable: true,
                required: true,
                example: '残高不足',
                description: '支払いが拒否された理由'
              },
              charge_id: {
                type: :string,
                nullable: true,
                required: true,
                example: 'charge_id-123',
                description: '支払いが拒否された理由'
              },
              email_id: {
                type: :string,
                nullable: true,
                required: true,
                example: 'email_id-123',
                description: 'メールID'
              },
              fulfillment_request_id: {
                type: :string,
                nullable: true,
                required: true,
                example: 'fulfillment_request_id-123',
                description: 'フルフィルメントリクエストID'
              }
            }
          },
          new_order_input_form: {
            description: '新規注文(Order)のパラメータ',
            type: :object,
            properties: {
              product_id: {
                type: :integer,
                nullable: true,
                required: true,
                example: 321,
                description: '製品ID'
              },
              quantity: {
                type: :integer,
                nullable: true,
                required: true,
                example: 99,
                description: '数量',
                minimum: 1
              },
              address: {
                type: :string,
                nullable: true,
                required: true,
                example: '東京都港区芝公園4丁目2-8 東京タワー',
                description: '配達先の住所'
              },
              email: {
                type: :string,
                nullable: true,
                required: true,
                email: 'test@example.com',
                description: '連絡先メールアドレス'
              }
            }
          }
        }
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000'
        }
      ]
    }
  }
  config.openapi_format = :yaml

  # responseに未知のプロパティが含まれる場合の挙動
  # strictにするかしないか
  # default: false(PASSする)
  config.openapi_strict_schema_validation = true
end
