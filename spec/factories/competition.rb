# frozen_string_literal: true

FactoryBot.define do
  factory :competition do
    name { FFaker::AnimalUS.common_name }
  end
end
