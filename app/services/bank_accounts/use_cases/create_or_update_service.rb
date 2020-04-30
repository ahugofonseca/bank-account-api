# frozen_string_literal: true

module BankAccounts
  module UseCases
    # Use case responsible to create or update BankAccount to Client
    class CreateOrUpdateService < ApplicationService
      def initialize(**args)
        @bank_account = args.dig(:bank_account)
        @referral_code = args.dig(:referral_code)
      end

      private

      # BUSINESS VALIDATIONS
      def execute_specifications
        bank_account_valid_data
      end

      def bank_account_valid_data
        return if @bank_account.valid?

        raise ActiveModel::ValidationError, @bank_account
      end

      # PERFORM USE CASE
      def execute_use_case
        set_bank_account
        set_account_status
        set_referral_code
        set_association_with_inviter

        client_account.save!
      rescue ActiveRecord::RecordInvalid
        # NOTE: This rescue is to try generate Referral Code more 10 times
        # It's improbable collision. There are 36^8 differents combinations
        # at each attempt.

        if client_account.errors[:referral_code].present?
          set_referral_code

          raise ReferralCodeCollisionError unless client_account.save
        end
      end

      def set_bank_account
        client_account.assign_attributes(@bank_account.as_json)
      end

      def set_account_status
        client_account.bank_account_status = bank_account_status
      end

      def set_referral_code
        return unless client_account.complete?
        return if client_account.referral_code.present?

        10.times { break if Client.find_by(referral_code: token).blank? }

        client_account.referral_code = token
      end

      def token
        SecureRandom.alphanumeric(8).upcase
      end

      def set_association_with_inviter
        return if @referral_code.nil?

        client_account.inviter = Client.find_by!(referral_code: @referral_code)
      end

      # USE CASE RESPONSE
      def use_case_response
        presenter_factory&.data || client_account.bank_account
      end

      def presenter_factory
        Factories::PresentersFactory.for(client_account.bank_account_status,
                                         client_account.bank_account)
      end

      # OTHERS METHODS
      def client_account
        @client_account ||= Client.find_or_initialize_by(cpf: @bank_account.cpf)
      end

      def bank_account_status
        bank_account_is_complete? ? :complete : :pending
      end

      def bank_account_is_complete?
        %i[name email cpf birth_date gender city state country].all? do |attr|
          client_account.bank_account.send(attr).present?
        end
      end
    end
  end
end
