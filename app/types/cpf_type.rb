# frozen_string_literal: true

# Get and set to CPF using ActiveRecord API to create Custom Type
class CpfType < ActiveModel::Type::String
  def deserialize(value)
    CPF.new(super).formatted
  end

  def serialize(value)
    value = CPF.new(value).stripped

    super
  end
end
