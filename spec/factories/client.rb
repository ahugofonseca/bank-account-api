# frozen_string_literal: true

FactoryBot.define do
  factory :client, aliases: [:bank_account_completed] do
    cpf                   { '366.012.360-98' }
    password              { '123456' }
    password_confirmation { '123456' }
    name                  { Faker::Name.name }
    email                 { Faker::Internet.unique.email }
    birth_date            { Faker::Date.birthday(min_age: 18) }
    gender                { %i[male female other].sample }
    city                  { Faker::Address.city }
    state                 { Faker::Address.state }
    country               { Faker::Address.country }
    referral_code         { Faker::Alphanumeric.alphanumeric(number: 8).upcase }
    bank_account_status   { :complete }

    trait :with_invalid_cpf do
      cpf { '123.456.789-00' }
    end

    trait :bank_account_pending do
      cpf                 { CPF.generate(true) }
      gender              { nil }
      referral_code       { nil }
      bank_account_status { :pending }
    end

    trait :bank_account_not_opened do
      cpf                 { CPF.generate(true) }
      name                { nil }
      email               { nil }
      birth_date          { nil }
      gender              { nil }
      city                { nil }
      state               { nil }
      country             { nil }
      referral_code       { nil }
      bank_account_status { :not_open_yet }
    end
  end
end
