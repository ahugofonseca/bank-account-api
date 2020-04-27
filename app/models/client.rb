# frozen_string_literal: true

# Final user of the application
class Client < ApplicationRecord
  has_secure_password

  # Active Record attributes API
  attribute :name, :encrypted, random_iv: false
  attribute :email, :encrypted, random_iv: false
  attribute :cpf, :encrypted, type: :cpf, random_iv: false
  attribute :birth_date, :encrypted, type: :date, random_iv: false

  # Enums
  enum gender: %i[male female other]
  enum bank_account_status: %i[not_open_yet pending complete]

  # Validations
  validates :cpf, presence: true,
                  uniqueness: true,
                  cpf: true

  # Methods
  def bank_account
    BankAccount.new(slice(:name, :email, :cpf, :birth_date, :gender, :city,
                          :state, :country, :referral_code))
  end
end
