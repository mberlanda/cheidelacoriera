# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :home_team, class_name: Team
  belongs_to :away_team, class_name: Team
  belongs_to :competition, inverse_of: :events

  has_many :trips, inverse_of: :event, dependent: :nullify
  scope :upcoming, ->() { where('date >= ?', Date.today) }

  def to_s
    "#{home_team.name} vs #{away_team.name} (#{competition}, #{date})"
  end

  class << self
    def include_all
      includes(:competition, :home_team, :away_team)
    end
  end
end
