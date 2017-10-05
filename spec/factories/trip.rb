# frozen_string_literal: true

FactoryGirl.define do
  factory :trip do
    total_seats { 100 }
    available_seats { 95 }
    requested_seats { 20 }
    reserved_seats { 5 }
    transport_mean
    event
  end
end
