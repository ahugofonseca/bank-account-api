# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BankAccount', type: :request do
  describe 'POST /bank_accounts' do
    context 'when send different cpf from logged in' do
      before(:all) do
        # Set attributes
        client = build_stubbed(:client)
        client2 = create(:client, cpf: '691.605.320-84')

        # Make request
        valid_jwt = JsonWebToken.encode(user_id: client2.id)
        post api_v1_bank_accounts_url,
             headers: { 'Authorization': valid_jwt },
             params: { bank_account: { cpf: client.cpf, name: 'Teste Silva' } }
      end

      it 'return status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it_should_behave_like('attr in error response', 'status', nil, true)
      it_should_behave_like('attr in error response', 'message', nil, true)
      it_should_behave_like('attr in error response', 'details', nil, true)
    end

    context 'when complete the opening bank account' do
      before(:all) do
        # Clients with Bank Account pending
        bank_account_pending = create(:client, :bank_account_pending)

        # Make request
        valid_jwt = JsonWebToken.encode(user_id: bank_account_pending.id)
        post api_v1_bank_accounts_url,
             headers: { 'Authorization': valid_jwt },
             params: {
               bank_account: { cpf: bank_account_pending.cpf, gender: 'male' }
             }
      end

      it 'return status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'return referral_code' do
        expect(
          JSON.parse(response.body).dig('referral_code').present?
        ).to eq(true)
      end

      it 'return message' do
        expect(
          JSON.parse(response.body).dig('message').present?
        ).to eq(true)
      end
    end

    context 'when pending the opening bank account' do
      before(:all) do
        # Clients with Bank Account pending
        bank_account_not_opened =
          create(:client, :bank_account_not_opened)

        # Make request
        valid_jwt = JsonWebToken.encode(user_id: bank_account_not_opened.id)
        post api_v1_bank_accounts_url,
             headers: { 'Authorization': valid_jwt },
             params: {
               bank_account: {
                 cpf: bank_account_not_opened.cpf, gender: 'male'
               }
             }
      end

      it 'return status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'return message' do
        expect(
          JSON.parse(response.body).dig('message').present?
        ).to eq(true)
      end
    end
  end
end
