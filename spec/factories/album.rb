# frozen_string_literal: true

FactoryBot.define do
  factory :album do
    title { FFaker::Animal.common_name }
    url { FFaker::Internet.http_url }
  end
end
