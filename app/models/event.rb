# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :home_team, class_name: Team
  belongs_to :away_team, class_name: Team
  belongs_to :competition, inverse_of: :events

  scope :upcoming, ->() { where('date >= ?', Date.today) }

  has_many :reservations, inverse_of: :event, dependent: :destroy
  has_one :album, inverse_of: :event, dependent: :nullify

  extend FriendlyId

  before_validation :set_slug_name!
  validates :custom_name, presence: true
  friendly_id :custom_name, use: %i[slugged history finders]

  class << self
    def include_all
      includes(:competition, :home_team, :away_team, :reservations)
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

  private

  def set_slug_name!
    self.custom_name = custom_slug_name
  end

  def custom_slug_name
    [
      home_team.name.downcase.tr(' ', '-'),
      away_team.name.downcase.tr(' ', '-'),
      competition.name.downcase.tr(' ', '-'),
      date
    ].join('-')
  rescue NoMethodError
    nil
  end

  def should_generate_new_friendly_id?
    slug.blank? || home_team_id_changed? ||
      away_team_id_changed? || competition_id_changed? || date_changed?
  end
end
