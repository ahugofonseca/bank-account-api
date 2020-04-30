# frozen_string_literal: true

# Module responsable to handle with authentication particulaties
module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    alias_method :current_user, :current_client
  end

  def authenticate_request!
    @auth_payload, @auth_header = validate_authentication
    current_client
  rescue ActiveRecord::RecordNotFound
    handling_exception(:not_found, 'api.record_not_found')
  rescue JWT::VerificationError, JWT::DecodeError
    handling_exception(:unauthorized, 'api.unauthorized')
  rescue JWT::ExpiredSignature
    handling_exception(:forbidden, 'api.expired_signature')
  rescue JWT::InvalidIssuerError
    handling_exception(:forbidden, 'api.invalid_issuer_error')
  rescue JWT::InvalidIatError
    handling_exception(:forbidden, 'api.invalid_iat_error')
  end

  private

  def current_client
    @current_client ||= Client.find(@auth_payload[:user_id])
  end

  def http_token
    request.headers['Authorization']&.split(' ')&.last
  end

  def validate_authentication
    JsonWebToken.decode(http_token)
  end
end
