# frozen_string_literal: true

FactoryBot.define do

  factory :player do
    name { Faker::Name.name }
    vekn { Faker::Number.number(digits: 7) }
    country { Faker::Address.country_code }
    email { Faker::Internet.email }
  end

end
