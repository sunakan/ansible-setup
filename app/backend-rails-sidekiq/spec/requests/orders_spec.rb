require 'swagger_helper'

RSpec.describe 'orders', type: :request do
  path '/orders/new' do
    get('new order') do
      consumes 'application/json'
      produces 'application/json'
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 order: {
                   '$ref' => '#/components/schemas/new_order_input_form'
                 },
                 products: {
                   type: :array,
                   items: {
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
                       price_cents: {
                         type: :integer,
                         required: true,
                         example: 100,
                         description: '価格(セント)',
                         minimum: 0
                       }
                     }
                   }
                 }
               }
        run_test! do |response|
          expected = <<~JSON
            {
              "order": {
                "product_id": 1,
                "email": "",
                "quantity": 1,
                "address": ""
              },
              "products": [
                { "name": "MacBook Pro(M4)", "price_cents": 12300 },
                { "name": "Mac mini(M4)", "price_cents": 567800 },
                { "name": "iPhone", "price_cents": 76599 },
                { "name": "iPad", "price_cents": 1244 }
              ]
            }
          JSON
          expect(response.body).to be_json_eql(expected)
        end
      end
    end
  end

  path '/orders' do
    post('create order') do
      consumes 'application/json'
      produces 'application/json'
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          product_id: {
            type: :integer,
            example: '321',
            description: '製品ID',
            required: true
          },
          quantity: {
            type: :integer,
            example: '99',
            description: '数量',
            minimum: 1,
            required: true
          },
          address: {
            type: :string,
            example: '東京都港区芝公園4丁目2-8 東京タワー',
            description: '配達先の住所',
            required: true
          },
          email: {
            type: :string,
            example: 'test@example.com',
            description: '連絡先メールアドレス',
            required: true
          }
        }
      }

      response(201, 'successful') do
        let(:order) {
          {
            product_id: 1,
            quantity: 1,
            address: "東京都墨田区押上1丁目1-2 東京スカイツリー",
            email: "test@example.com"
          }
        }
        schema '$ref' => '#/components/schemas/order'
        run_test! do |response|
          expected = {
            product_id: 1,
            quantity: 1,
            address: "東京都墨田区押上1丁目1-2 東京スカイツリー",
            email: "test@example.com",
            user_id: 1,
            charge_completed_at: nil,
            charge_successful: false,
            charge_decline_reason: nil,
            charge_id: nil,
            email_id: nil,
            fulfillment_request_id: nil
          }.to_json
          expect(response.body).to be_json_eql(expected)

          parsed = JSON.parse(response.body)
          expect(parsed['created_at']).to be_valid_iso8601_jst_with_milliseconds
          expect(parsed['updated_at']).to be_valid_iso8601_jst_with_milliseconds
        end
      end

      response(400, 'successful') do
        let(:order) {
          {
            product_id: 1,
            quantity: nil,
            address: "東京都墨田区押上1丁目1-2 東京スカイツリー",
            email: "test@example.com"
          }
        }
        schema type: :object,
               properties: {
                 order: {
                   '$ref' => '#/components/schemas/new_order_input_form'
                 },
                 order_errors: {
                   description: 'エラーメッセージ群',
                   type: :array,
                   required: true,
                   items: { type: :string },
                   example: [ "Can't foo" ]
                 },
                 products: {
                   type: :array,
                   items: {
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
                       price_cents: {
                         type: :integer,
                         required: true,
                         example: 100,
                         description: '価格(セント)',
                         minimum: 0
                       }
                     }
                   }
                 }
               }
        run_test! do |response|
          expected = <<~JSON
            {
              "order": {
                "product_id": 1,
                "quantity": null,
                "address": "東京都墨田区押上1丁目1-2 東京スカイツリー",
                "email": "test@example.com"
              },
              "order_errors": [
                "Quantity can't be blank",
                "Quantity is not a number"
              ],
              "products": [
                { "name": "MacBook Pro(M4)", "price_cents": 12300 },
                { "name": "Mac mini(M4)", "price_cents": 567800 },
                { "name": "iPhone", "price_cents": 76599 },
                { "name": "iPad", "price_cents": 1244 }
              ]
            }
          JSON
          expect(response.body).to be_json_eql(expected)
        end
      end
    end
  end

  path '/orders/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: '注文ID', example: 123
    get('show order') do
      consumes 'application/json'
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { 1 }
        schema type: :object,
               properties: {
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
                     },
                     product: {
                       description: '製品(Product)',
                       type: :object,
                       properties: {
                         name: {
                           type: :string,
                           required: true,
                           example: 'MacBook Pro(M4)',
                           description: '製品名'
                         },
                         price_cents: {
                           type: :integer,
                           required: true,
                           example: 12300,
                           description: '価格(セント)',
                           minimum: 0
                         }
                       }
                     }
                   }
                 }
               }
        run_test! do |response|
          expected = <<~JSON
            {
              "order": {
                "address": "東京都港区芝公園4丁目2-8 東京タワー",
                "charge_completed_at": null,
                "charge_decline_reason": null,
                "charge_id": null,
                "charge_successful": false,
                "email": "test@example.com",
                "email_id": null,
                "fulfillment_request_id": null,
                "quantity": 1,
                "product": {
                  "name": "MacBook Pro(M4)",
                  "price_cents": 12300
                }
              }
            }
          JSON
          expect(response.body).to be_json_eql(expected)
        end
      end
    end
  end
end
