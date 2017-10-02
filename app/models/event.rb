# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :home_team, class_name: Team
  belongs_to :away_team, class_name: Team
  belongs_to :competition, inverse_of: :events

  def to_s
    "#{home_team.name} vs #{away_team.name} (#{competition}, #{date})"
  end
end
