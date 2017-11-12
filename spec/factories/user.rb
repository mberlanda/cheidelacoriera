# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password 'abcdefgh'
    password_confirmation 'abcdefgh'
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    date_of_birth { FFaker::Time.date }
    place_of_birth { FFaker::Address.city }
    phone_number { FFaker::PhoneNumber.phone_number }
  end
end
