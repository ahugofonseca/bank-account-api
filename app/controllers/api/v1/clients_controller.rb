# frozen_string_literal: true

module Api
  module V1
    # Responsable to handle request about client
    class ClientsController < ApiController
      skip_before_action :authenticate_request!, only: :create

      def create
        @client = Client.new(client_params)
        @client.save!

        render json: ClientSerializer.new(@client).serialized_json
      end

      private

      def client_params
        params.permit(:cpf, :password, :password_confirmation)
      end
    end
  end
end
