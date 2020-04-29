# frozen_string_literal: true

# Exception class when referral_code collision
class ReferralCodeCollisionError < StandardError
  def initialize(message_error = custom_message_error.to_s)
    super
  end

  private

  def custom_message_error
    I18n.t('api.referral_code_collision_error')
  end
end
