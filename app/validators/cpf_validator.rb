# frozen_string_literal: true

class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if CPF.valid?(value)

    record.errors[attribute] << (options[:message] || 'is not an cpf')
  end
end
