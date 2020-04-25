# frozen_string_literal: true

# Exception class when password passed is wrong to CPF informed
class InvalidPasswordError < StandardError
  def initialize(message_error = custom_message_error.to_s)
    super
  end

  private

  def custom_message_error
    I18n.t('api.invalid_password_error')
  end
end
