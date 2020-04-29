# frozen_string_literal: true

module Api
  module V1
    # Responsable to handle request about bank account
    class BankAccountsController < ApiController
      before_action :ensure_account_creation_by_yourself, only: :create

      def create
        @bank_account = BankAccount.new(bank_account_params)
        bank_account_service.call

        render json: bank_account_service.response
      end

      private

      def bank_account_params
        params.require(:bank_account)
              .permit(:name, :email, :cpf, :birth_date, :gender, :city, :state,
                      :country, :referral_code)
      end

      def ensure_account_creation_by_yourself
        raise DifferentCpfFromLoggedInError unless same_cpf_from_logged_in?
      end

      def same_cpf_from_logged_in?
        current_client.cpf == bank_account_params[:cpf]
      end

      def bank_account_service
        @bank_account_service ||= @bank_account.open_or_update_account
      end
    end
  end
end
