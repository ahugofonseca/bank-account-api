# frozen_string_literal: true

# Exception class to different cpf passed from logged in
class DifferentCpfFromLoggedInError < StandardError
  def initialize(message_error = custom_message_error.to_s)
    super
  end

  private

  def custom_message_error
    I18n.t('api.different_cpf_from_logged_in_error')
  end
end
