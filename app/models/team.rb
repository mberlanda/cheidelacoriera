# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true, allow_blank: false
  validates :country, presence: true, allow_blank: false
  validates :name, uniqueness: { scope: :country }

  # rubocop:disable Metrics/LineLength
  URL_REGEXP = %r[
    /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
  ]
  # rubocop:enable Metrics/LineLength

  # validates :url, format: { with: Team::URL_REGEXP }
  # validates :image_url, format: { with: Team::URL_REGEXP }
end
