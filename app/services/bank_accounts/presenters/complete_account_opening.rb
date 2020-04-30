# frozen_string_literal: true

module BankAccounts
  module Presenters
    # It format response after complete the opening Bank Account
    class CompleteAccountOpening
      def initialize(bank_account)
        @bank_account = bank_account
      end

      def data
        {
          message: user_message,
          referral_code: @bank_account.referral_code,
          bank_account: @bank_account.as_json
        }
      end

      private

      def user_message
        I18n.t('usage_massage.complete_opening_bank_account')
      end
    end
  end
end
