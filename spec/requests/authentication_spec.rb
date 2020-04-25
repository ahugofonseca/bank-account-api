# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /auth/login' do
    before(:all) do
      @client = FactoryBot.create(:client)
    end

    context 'when send a valid credentials' do
      before do
        post '/api/v1/auth/login', params: {
          authentication: { cpf: '366.012.360-98', password: '123456' }
        }
      end

      it 'returns the access token' do
        expect(JSON.parse(response.body)['access_token'].present?).to eq(true)
      end

      it 'returns when the access token will expire' do
        expect(JSON.parse(response.body)['expires_at'].present?).to eq(true)
      end

      it 'returns a ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when send invalid credentials' do
      before do
        post '/api/v1/auth/login', params: {
          authentication: { cpf: '366.012.360-18', password: '12345678' }
        }
      end

      it 'return error' do
        expect(JSON.parse(response.body)['error'].present?).to eq(true)
      end

      it 'return error status' do
        expect(
          JSON.parse(response.body).dig('error', 'status').present?
        ).to eq(true)
      end

      it 'return error message' do
        expect(
          JSON.parse(response.body).dig('error', 'message').present?
        ).to eq(true)
      end

      it 'return error details' do
        expect(
          JSON.parse(response.body).dig('error', 'details').present?
        ).to eq(true)
      end
    end

    context 'when send a invalid CPF' do
      before do
        post '/api/v1/auth/login', params: {
          authentication: { cpf: '366.012.360-18', password: '123456' }
        }
      end

      it 'return not_found status' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when send invalid password' do
      before do
        post '/api/v1/auth/login', params: {
          authentication: { cpf: '366.012.360-98', password: '12345678' }
        }
      end

      it 'return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
