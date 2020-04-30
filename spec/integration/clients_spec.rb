# frozen_string_literal: true

describe 'Clients API' do
  path '/api/v1/clients' do
    post 'Creates a client' do
      tags 'Client'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :client, in: :body, schema: {
        type: :object,
        properties: {
          cpf: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[cpf password password_confirmation]
      }

      response '201', 'client created' do
        let(:client) do
          {
            cpf: '366.012.360-98',
            password: '123456',
            password_confirmation: '123456'
          }
        end

        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     type: { type: :string },
                     attributes: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         cpf: { type: :string },
                         create_at: { type: :string }
                       }
                     }
                   }
                 }
               },
               required: %w[message bank_account]

        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 error: {
                   type: :object,
                   properties: {
                     status: { type: :string },
                     message: { type: :string },
                     details: { type: :string }
                   },
                   required: %w[status message details]
                 }
               },
               required: %w[error]
        run_test!
      end
    end
  end

  path '/api/v1/clients/my_indications' do
    get 'Listing my indications' do
      tags 'Client'
      consumes 'application/json'
      produces 'application/json'

      security [api_key: []]

      response '200', 'indications list' do
        let(:Authorization) { JsonWebToken.encode(user_id: create(:client).id) }
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :string },
                       type: { type: :string },
                       attributes: {
                         type: :object,
                         properties: {
                           id: { type: :string },
                           name: { type: :string }
                         }
                       }
                     }
                   }
                 }
               }
        run_test!
      end

      response '403', 'unauthorized' do
        let(:Authorization) { JsonWebToken.encode(user_id: create(:client).id) }
        schema type: :object,
               properties: {
                 error: {
                   type: :object,
                   properties: {
                     status: { type: :string },
                     message: { type: :string },
                     details: { type: :string }
                   },
                   required: %w[status message details]
                 }
               },
               required: %w[error]
        run_test!
      end
    end
  end
end
