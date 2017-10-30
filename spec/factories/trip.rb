# frozen_string_literal: true

FactoryGirl.define do
  factory :trip do
    total_seats { 100 }
    available_seats { 95 }
    requested_seats { 20 }
    reserved_seats { 5 }
    transport_mean
    name { FFaker::Animal.common_name }
    bookable_from { Date.new(2017, 9, 20) }
    bookable_until { Date.new(2019, 9, 20) }
    poster_url { FFaker::Avatar.image }
    event
  end
end
