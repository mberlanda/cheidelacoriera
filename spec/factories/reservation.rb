# frozen_string_literal: true

FactoryGirl.define do
  factory :reservation do
    total_seats { nil }
    fan_names { [] }
    fan_ids { [] }
    notes { '' }
    status { 'pending' }
    phone_number { FFaker::PhoneNumber.phone_number }
    user
    event
  end
end
