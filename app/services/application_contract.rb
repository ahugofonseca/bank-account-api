# frozen_string_literal: true

# Set configurations to Dry Validation
class ApplicationContract < Dry::Validation::Contract
  config.messages.default_locale = I18n.locale
  Dir['config/locales/*.yml'].map { |path| config.messages.load_paths << path }
end
