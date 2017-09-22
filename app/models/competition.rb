# frozen_string_literal: true

class Competition < ApplicationRecord
  has_many :events, inverse_of: :competition, dependent: :destroy
end
