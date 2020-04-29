# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ApiController, type: :controller do
  controller do
    include Authenticatable

    def private_action
      authenticate_request!
      head :ok
    end
  end

  before do
    routes.draw { get :private_action, to: 'api/v1/api#private_action' }
  end

  before(:all) do
    @client = create(:client)
  end

  context 'when send valid JWT' do
    let(:valid_jwt) { JsonWebToken.encode(user_id: @client.id) }

    it 'return status success (200)' do
      request.headers['Authorization'] = valid_jwt

      get :private_action, format: :json

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'invalid JWT' do
    context 'when not found resource present in JWT payload' do
      before(:all) do
        @client_stubbed = build_stubbed(:client)
        @invalid_jwt = JsonWebToken.encode(user_id: @client_stubbed.id)
      end

      it 'return status not found' do
        request.headers['Authorization'] = @invalid_jwt

        get :private_action, format: :json

        expect(response).to have_http_status(:not_found)
      end

      it_should_behave_like('attr in error response', 'status', @invalid_jwt)
      it_should_behave_like('attr in error response', 'message', @invalid_jwt)
      it_should_behave_like('attr in error response', 'details', @invalid_jwt)
    end

    context 'when send malformed jwt' do
      before(:all) do
        @invalid_jwt = SecureRandom.uuid
      end

      it 'return status not found' do
        request.headers['Authorization'] = @invalid_jwt

        get :private_action, format: :json

        expect(response).to have_http_status(:unauthorized)
      end

      it_should_behave_like('attr in error response', 'status', @invalid_jwt)
      it_should_behave_like('attr in error response', 'message', @invalid_jwt)
      it_should_behave_like('attr in error response', 'details', @invalid_jwt)
    end

    context 'when send expired signature jwt' do
      before(:all) do
        exp_time = Time.now - 1.day
        @invalid_jwt = JsonWebToken.encode({ user_id: @client.id }, exp_time)
      end

      it 'return status not found' do
        request.headers['Authorization'] = @invalid_jwt

        get :private_action, format: :json

        expect(response).to have_http_status(:unauthorized)
      end

      it_should_behave_like('attr in error response', 'status', @invalid_jwt)
      it_should_behave_like('attr in error response', 'message', @invalid_jwt)
      it_should_behave_like('attr in error response', 'details', @invalid_jwt)
    end

    context 'when send jwt with invalid iss' do
      # NOTE: Issuer Claim neither is being used nor has it been implemented.
      # Read more about in: https://tools.ietf.org/html/rfc7519#section-4.1.1

      it 'return status not found' do
        skip(
          "\sIssuer Claim neither is being used nor has it been implemented. \n" \
          "\tRead more about in: https://tools.ietf.org/html/rfc7519#section-4.1.1"
        )

        request.headers['Authorization'] = @invalid_jwt

        get :private_action, format: :json

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when send jwt with invalid iat' do
      # NOTE: Issued At Claim neither is being used nor has it been implemented.
      # Read more about in: https://tools.ietf.org/html/rfc7519#section-4.1.6

      it 'return status not found' do
        skip(
          "\sIssuer At Claim neither is being used nor has it been implemented. \n" \
          "\tRead more about in: https://tools.ietf.org/html/rfc7519#section-4.1.6"
        )

        request.headers['Authorization'] = @invalid_jwt

        get :private_action, format: :json

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
