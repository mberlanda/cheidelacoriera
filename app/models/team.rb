# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true, allow_blank: false
  validates :country, presence: true, allow_blank: false
  validates :name, uniqueness: { scope: :country }

  validates :url, http_url: true, allow_nil: true
  validates :image_url, http_url: true, allow_nil: true
end
