# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    cpf                   { '366.012.360-98' }
    password              { '123456' }
    password_confirmation { '123456' }

    trait :with_invalid_cpf do
      cpf { '123.456.789-00' }
    end
  end
end
