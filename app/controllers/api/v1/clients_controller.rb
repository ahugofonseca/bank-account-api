# frozen_string_literal: true

module Api
  module V1
    # Responsable to handle request about client
    class ClientsController < ApiController
      skip_before_action :authenticate_request!, only: :create

      def create
        @client = Client.new(client_params)
        @client.save!

        render json: ClientSerializer.new(@client).serialized_json,
               status: :created
      end

      def my_indications
        @guests = current_client.guests

        render json: GuestSerializer.new(@guests).serialized_json
      end

      private

      def client_params
        params.permit(:cpf, :password, :password_confirmation)
      end
    end
  end
end
