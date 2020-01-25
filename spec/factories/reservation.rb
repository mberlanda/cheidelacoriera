# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    total_seats { nil }
    fan_names { [] }
    notes { '' }
    status { 'pending' }
    phone_number { FFaker::PhoneNumber.phone_number }
    user { FactoryBot.create(:user) }
    event { FactoryBot.create(:event) }
  end
end
