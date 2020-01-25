# frozen_string_literal: true

FactoryBot.define do
  factory :transport_mean do
    kind { FFaker::AnimalUS.common_name }
    company { FFaker::Company.name }
    phone_number { FFaker::PhoneNumber.phone_number }
    email { FFaker::Internet.email }
  end
end
