# frozen_string_literal: true

module BankAccounts
  module ServiceContracts
    # Use case responsible to create or update BankAccount to Client
    class CreateOrUpdateService < ApplicationContract
      params do
        required(:bank_account)
      end

      rule(:bank_account) do
        key.failure(:invalid_instance) unless value.is_a?(BankAccount)
      end
    end
  end
end
