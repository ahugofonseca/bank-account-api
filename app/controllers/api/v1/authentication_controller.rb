# frozen_string_literal: true

module Api
  module V1
    # Responsable to handle request about authentication
    class AuthenticationController < ApiController
      skip_before_action :authenticate_request!

      # POST /auth/login
      def login
        @client = Client.find_by_cpf!(cpf_param)

        raise InvalidPasswordError unless client_authenticated?

        render status: :ok,
               json: { access_token: access_token, expires_at: expires_at }
      end

      private

      def login_params
        params.require(:authentication).permit(:cpf, :password)
      end

      def cpf_param
        CPF.new(login_params[:cpf]).formatted
      end

      def client_authenticated?
        @client&.authenticate(login_params[:password])
      end

      def access_token
        @access_token ||= JsonWebToken.encode(user_id: @client.id)
      end

      def expires_at
        DateTime.strptime(JsonWebToken.decode(access_token)[:exp].to_s, '%s')
      end
    end
  end
end
