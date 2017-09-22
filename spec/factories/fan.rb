# frozen_string_literal: true

FactoryGirl.define do
  factory :fan do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    date_of_birth { FFaker::Time.date }
    place_of_birth { FFaker::Address.city }
    fidelity_card_no { FFaker::IdentificationBR.cpf }
    user
  end
end
