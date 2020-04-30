# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Clients', type: :request do
  describe 'POST /clients' do
    context 'when send a invalid CPF' do
      before do
        post '/api/v1/clients', params: {
          cpf: '366.012.360-18',
          password: '123456',
          password_confirmation: '123456'
        }
      end

      it 'return error' do
        expect(JSON.parse(response.body)['error'].present?).to eq(true)
      end

      it_should_behave_like('attr in error response', 'status', nil, true)
      it_should_behave_like('attr in error response', 'message', nil, true)
      it_should_behave_like('attr in error response', 'details', nil, true)

      it 'return not_found status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when send a valid CPF' do
      before do
        post '/api/v1/clients', params: {
          cpf: '366.012.360-98',
          password: '123456',
          password_confirmation: '123456'
        }
      end

      it 'returns data' do
        expect(JSON.parse(response.body)['data'].present?).to eq(true)
      end

      it_should_behave_like('attr in success response', 'id')
      it_should_behave_like('attr in success response', 'type')
      it_should_behave_like('attr in success response', 'attributes')

      it_should_behave_like('attr in success response', 'attributes', 'id')
      it_should_behave_like('attr in success response', 'attributes', 'cpf')
      it_should_behave_like('attr in success response', 'attributes', 'created_at')
    end
  end

  describe 'GET /clients/my_indications' do
    before do
      inviter = create(:client)
      valid_jwt = JsonWebToken.encode(user_id: inviter.id)

      create(:client, :bank_account_pending, inviter: inviter)

      get my_indications_api_v1_clients_url,
          headers: { 'Authorization': valid_jwt }
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of guests' do
      expect(JSON.parse(response.body).dig('data').is_a?(Array)).to be_truthy
    end

    it 'return ids of the guests' do
      expect(
        JSON.parse(response.body).dig('data').pluck('id').present?
      ).to be_truthy
    end

    it 'return names of the guests' do
      expect(
        JSON.parse(response.body).dig('data').pluck('name').present?
      ).to be_truthy
    end
  end
end
