# frozen_string_literal: true

FactoryBot.define do
  factory :client do
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
    referral_code         { Faker::Alphanumeric.alphanumeric(number: 16) }

    trait :with_invalid_cpf do
      cpf { '123.456.789-00' }
    end
  end
end
