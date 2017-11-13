# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :home_team, class_name: Team
  belongs_to :away_team, class_name: Team
  belongs_to :competition, inverse_of: :events

  scope :upcoming, ->() { where('date >= ?', Date.today) }

  has_many :reservations, inverse_of: :event, dependent: :destroy
  has_one :album, inverse_of: :event, dependent: :nullify

  class << self
    def include_all
      includes(:competition, :home_team, :away_team)
    end

    def bookable(d = Date.today)
      where('bookable_from <= ? and bookable_until >= ?', d, d)
    end
  end

  def to_s
    "#{home_team.name} vs #{away_team.name} (#{competition}, #{date})"
  end

  def book_range?
    bookable_from && bookable_until
  end

  def bookable?(d = Date.today)
    return false unless book_range?
    bookable_from <= d && bookable_until >= d
  end

  def booked_by?(user_id)
    return false unless book_range?
    reservations.where(user_id: user_id).present?
  end
end
