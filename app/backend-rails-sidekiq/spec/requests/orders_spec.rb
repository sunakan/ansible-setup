require 'swagger_helper'

RSpec.describe 'orders', type: :request do

  path '/orders' do
    post('create order') do
      consumes 'application/json'
      produces 'application/json'
      response(200, 'successful') do
        schema type: :object,
                properties: {
                  message: { type: :string }
                },
                required: %w[message]
        run_test! do |response|
          expected = { message: 'todo' }.to_json
          expect(response.body).to be_json_eql(expected)
        end
      end
    end
  end

  path '/orders/new' do
    get('new order') do
      consumes 'application/json'
      produces 'application/json'
      response(200, 'successful') do
        schema type: :object,
                properties: {
                  message: { type: :string }
                },
                required: %w[message]
        run_test! do |response|
          expected = { message: 'todo' }.to_json
          expect(response.body).to be_json_eql(expected)
        end
      end
    end
  end

  path '/orders/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: '注文のid', example: 123
    get('show order') do
      consumes 'application/json'
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { '123' }
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: %w[message]
        run_test! do |response|
          expected = { message: 'todo' }.to_json
          expect(response.body).to be_json_eql(expected)
        end
      end
    end
  end
end
