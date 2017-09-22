# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true, allow_blank: false
  validates :country, presence: true, allow_blank: false
  validates :name, uniqueness: { scope: :country }

  validates :url, http_url: true, allow_nil: true
  validates :image_url, http_url: true, allow_nil: true

  has_many :home_events, class_name: Event,
                         foreign_key: :home_team_id, dependent: :destroy
  has_many :away_events, class_name: Event,
                         foreign_key: :away_team_id, dependent: :destroy

  def events
    [*home_events, *away_events]
  end
end
