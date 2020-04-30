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

  # Associations
  belongs_to :inviter, class_name: 'Client', optional: true
  has_many :guests, class_name: 'Client', foreign_key: 'inviter_id'

  # Validations
  validates :email, email: true, if: -> { email.present? }
  validates :referral_code, uniqueness: true,
                            length: { minimum: 8, maximum: 8 },
                            if: -> { referral_code.present? }

  validates :cpf, presence: true,
                  uniqueness: true,
                  cpf: true,
                  length: { minimum: 11, maximum: 14 }

  # Methods
  def bank_account
    BankAccount.new(slice(:name, :email, :cpf, :birth_date, :gender, :city,
                          :state, :country, :referral_code))
  end
end
