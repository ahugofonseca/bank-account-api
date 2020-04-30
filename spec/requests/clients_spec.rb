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
      it 'returns id in data' do
        expect(
          JSON.parse(response.body).dig('data', 'id').present?
        ).to eq(true)
      end
      it 'returns type in data' do
        expect(
          JSON.parse(response.body).dig('data', 'type').present?
        ).to eq(true)
      end
      it 'returns attributes in data' do
        expect(
          JSON.parse(response.body).dig('data', 'attributes').present?
        ).to eq(true)
      end
      it 'returns id in attributes' do
        expect(
          JSON.parse(response.body).dig('data', 'attributes', 'id').present?
        ).to eq(true)
      end
      it 'returns CPF in attributes' do
        expect(
          JSON.parse(response.body).dig('data', 'attributes', 'cpf').present?
        ).to eq(true)
      end
      it 'returns created_at in attributes' do
        expect(
          JSON.parse(response.body).dig('data', 'attributes', 'created_at').present?
        ).to eq(true)
      end
    end
  end
end
