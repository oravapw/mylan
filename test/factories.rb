# frozen_string_literal: true

FactoryBot.define do

  factory :player do
    name { Faker::Name.name }
    vekn { Faker::Number.number(digits: 7) }
    country { Faker::Address.country_code }
    email { Faker::Internet.email }
  end

  factory :tournament do
    sequence(:name) { |n| "Test tournament #{n}" }
    location { Faker::Address.full_address }
    organizers { Faker::Name.name }
    date { Time.now + (3600 * rand(1..1000)) }
    decklists { true }
    notes { "Note for #{name}" }
    prereg { true }
    prereg_slug { Tournament.generate_slug_for(name) }
    prereg_info { "Prereg info for #{name}" }
    prereg_end { date }
    proxies { false }
    decklist_delay { 0 }

    factory :past_tournament do
      date { Time.now - (3600 * rand(1..1000)) }
    end
  end
end
