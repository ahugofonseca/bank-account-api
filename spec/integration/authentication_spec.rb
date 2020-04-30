# frozen_string_literal: true

describe 'Authentication API' do
  path '/api/v1/auth/login' do
    post 'Authenticates with basic auth' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :authentication, in: :body, schema: {
        type: :object,
        properties: {
          cpf: { type: :string },
          password: { type: :string }
        },
        required: %w[cpf password]
      }

      response '200', 'Valid credentials' do
        let(:Authorization) { JsonWebToken.encode(user_id: create(:client).id) }
        let(:expires_at) { Time.now + 24.hours }

        schema type: :object,
               properties: {
                 access_token: { type: :string },
                 expires_at: { type: :string }
               },
               required: %w[access_token expires_at]

        run_test!
      end

      response '401', 'Invalid credentials' do
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

      response '404', 'not_found' do
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
