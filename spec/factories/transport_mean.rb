# frozen_string_literal: true

FactoryGirl.define do
  factory :transport_mean do
    kind { FFaker::Animal.common_name }
    company { FFaker::Company.name }
    phone_number { FFaker::PhoneNumber.phone_number }
    email { FFaker::Internet.email }
  end
end
