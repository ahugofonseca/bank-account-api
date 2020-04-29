# frozen_string_literal: true

# Model class to handle BankAccount business rules
class BankAccount
  include ActiveModel::Model

  # Attributes
  attr_accessor :name, :email, :cpf, :birth_date, :gender, :city, :state,
                :country, :referral_code

  # Validations
  validates :email, email: true, if: -> { email.present? }
  validates :cpf, presence: true,
                  cpf: true,
                  length: { minimum: 11, maximum: 14 }

  # Methods
  def client_account
    Client.find_by(cpf: CPF.new(cpf).formatted)
  end

  #  Default serializer
  def as_json(options = {})
    options.merge!(except: %w[validation_context errors])

    super
  end

  # Use cases
  def open_or_update_account
    BankAccounts::UseCases::CreateOrUpdateService.new(self)
  end
end
