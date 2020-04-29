# frozen_string_literal: true

FactoryBot.define do
  factory :bank_account, aliases: [:valid_and_complete] do
    cpf                   { '366.012.360-98' }
    name                  { Faker::Name.name }
    email                 { Faker::Internet.unique.email }
    birth_date            { Faker::Date.birthday(min_age: 18) }
    gender                { %i[male female other].sample }
    city                  { Faker::Address.city }
    state                 { Faker::Address.state }
    country               { Faker::Address.country }
    referral_code         { Faker::Alphanumeric.alphanumeric(number: 8).upcase }

    trait :with_invalid_cpf do
      cpf { '123.456.789-00' }
    end

    trait :with_invalid_email do
      email { 'a.com.br' }
    end

    trait :account_pending do
      cpf                 { CPF.generate(true) }
      gender              { nil }
      city                { nil }
    end

    trait :account_not_opened do
      cpf                 { CPF.generate(true) }
      name                { nil }
      email               { nil }
      birth_date          { nil }
      gender              { nil }
      city                { nil }
      state               { nil }
      country             { nil }
      referral_code       { nil }
    end
  end
end
