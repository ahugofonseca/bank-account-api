# frozen_string_literal: true

describe 'Bank Account API' do
  path '/api/v1/bank_accounts' do
    post 'Open or Update a bank account' do
      tags 'Bank Account'
      consumes 'application/json'
      produces 'application/json'

      security [api_key: []]

      parameter name: :bank_account, in: :body, schema: {
        type: :object,
        properties: {
          cpf: { type: :string },
          name: { type: :string },
          email: { type: :string },
          birth_date: { type: :string },
          gender: { type: :string },
          city: { type: :string },
          state: { type: :string },
          country: { type: :string },
          referral_code: { type: :string }
        },
        required: %w[cpf]
      }

      response '200', 'bank account opened' do
        let(:Authorization) { JsonWebToken.encode(user_id: create(:client).id) }

        schema type: :object,
               properties: {
                 message: { type: :string },
                 bank_account: { type: :string },
                 referral_code: { type: :string }
               },
               required: %w[message bank_account]

        run_test!
      end

      response '401', 'unauthorized' do
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

      response '401', 'invalid request' do
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
