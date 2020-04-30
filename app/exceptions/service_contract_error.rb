# frozen_string_literal: true

# Exception class when referral_code collision
class ServiceContractError < StandardError
  def initialize(message_error = custom_message_error.to_s)
    super
  end

  private

  def custom_message_error
    I18n.t('dry_validation.errors.default_message')
  end
end
