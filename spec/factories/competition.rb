# frozen_string_literal: true

FactoryGirl.define do
  factory :competition do
    name { FFaker::Animal.common_name }
  end
end
