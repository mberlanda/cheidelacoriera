# frozen_string_literal: true

FactoryGirl.define do
  factory :album do
    title { FFaker::Animal.common_name }
    url { FFaker::Internet.http_url }
  end
end
