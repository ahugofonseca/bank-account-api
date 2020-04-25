# frozen_string_literal: true

# Final user of the application
class Client < ApplicationRecord
  has_secure_password

  # Validations
  validates :cpf, presence: true,
                  uniqueness: true,
                  cpf: true,
                  length: { minimum: 11, maximum: 11 }

  # Callbacks
  before_validation :normalize_cpf!

  private

  def normalize_cpf!
    self.cpf = CPF.new(cpf).stripped
  end
end
