# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { FFaker::AnimalUS.common_name }
    image_url { FFaker::Avatar.image }
    content { FFaker::Lorem.paragraph }
  end
end
