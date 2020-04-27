# frozen_string_literal: true

# Model class to handle BankAccount business rules
class BankAccount
  include ActiveModel::Model

  # Attributes
  attr_accessor :name, :email, :cpf, :birth_date, :gender, :city, :state,
                :country, :referral_code, :bank_account_status, :client

  # Validations
  validates :email, email: true, if: -> { email.present? }
  validates :cpf, presence: true,
                  cpf: true,
                  length: { minimum: 11, maximum: 11 }
end
