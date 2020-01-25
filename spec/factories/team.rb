# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { FFaker::AnimalUS.common_name }
    country { FFaker::Name.last_name }
    url { FFaker::Internet.http_url }
    image_url { FFaker::Avatar.image }
    description { FFaker::IdentificationBR.cpf }
  end
end
