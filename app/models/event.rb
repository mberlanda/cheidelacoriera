# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :home_team, class_name: Team
  belongs_to :away_team, class_name: Team
  belongs_to :competition, inverse_of: :events

  has_one :trip, inverse_of: :event, dependent: :nullify
  scope :upcoming, ->() { where('date >= ?', Date.today) }
  delegate :reservations, to: :trip

  def to_s
    "#{home_team.name} vs #{away_team.name} (#{competition}, #{date})"
  end

  def any_trip?
    trip.present?
  end

  def booked_by?(user_id)
    return false unless any_trip?
    reservations.where(user_id: user_id).present?
  end

  def bookable?
    return false unless any_trip?
    trip.bookable.present?
  end

  class << self
    def include_all
      includes(:competition, :home_team, :away_team, :trip)
    end
  end
end
