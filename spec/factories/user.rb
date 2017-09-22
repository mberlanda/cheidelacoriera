# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password 'abcdefgh'
    password_confirmation 'abcdefgh'
  end
end
