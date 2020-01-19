# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { 'abcdefgh' }
    password_confirmation { 'abcdefgh' }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    date_of_birth { FFaker::Time.date }
    place_of_birth { FFaker::Address.city }
    phone_number { FFaker::PhoneNumber.phone_number }
    role { 'fan' }
    status { 'pending' }
  end
end
