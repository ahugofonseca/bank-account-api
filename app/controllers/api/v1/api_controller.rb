# frozen_string_literal: true

require 'json_web_token'

module Api
  module V1
    # Generical controller to API
    class ApiController < ApplicationController
      include Authenticatable

      around_action :handle_exception

      def handle_exception
        yield
      rescue InvalidPasswordError
        handling_exception(:unauthorized, 'api.invalid_password_error')
      rescue ActiveRecord::RecordInvalid => e
        handling_exception(:unprocessable_entity, 'api.unprocessable_entity', e)
      rescue ActiveRecord::RecordNotFound
        handling_exception(:not_found, 'api.record_not_found')
      rescue StandardError => e
        handling_exception(:internal_server_error, 'api.internal_error', e)
      end

      private

      def handling_exception(status_code, message_title, exception = 'api.not_applicable')
        error = {
          status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status_code],
          message: I18n.t(message_title),
          details: I18n.t(exception, default: exception)
        }

        render json: { error: error }, status: status_code
      end
    end
  end
end
