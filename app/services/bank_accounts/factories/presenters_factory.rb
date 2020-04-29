# frozen_string_literal: true

module BankAccounts
  module Factories
    # Factories to call presenter by key
    class PresentersFactory
      PRESENTERS_KLASS = {
        pending: Presenters::PartialAccountOpening,
        complete: Presenters::CompleteAccountOpening
      }.freeze

      def self.for(key, data)
        PRESENTERS_KLASS[key&.to_sym]&.new(data)
      end
    end
  end
end
