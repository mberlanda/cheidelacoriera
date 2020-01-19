# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { FFaker::Animal.common_name }
    image_url { FFaker::Avatar.image }
    content { FFaker::Lorem.paragraph }
  end
end
