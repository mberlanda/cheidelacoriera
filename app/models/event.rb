# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :home_team, class_name: Team
  belongs_to :away_team, class_name: Team
  belongs_to :competition, inverse_of: :events

  scope :upcoming, ->() { where('date >= ?', Date.today) }

  has_many :reservations, inverse_of: :event, dependent: :destroy
  has_many :albums, inverse_of: :event, dependent: :nullify

  extend FriendlyId
  include BookableEvent

  before_validation :cleanup_params
  validates :custom_name, presence: true
  friendly_id :custom_name, use: %i[slugged history finders]

  class << self
    def include_all
      includes(:competition, :home_team, :away_team, :reservations)
    end
  end

  def to_s
    "#{home_team.name} vs #{away_team.name} #{transport_mean} (#{competition}, #{date})"
  end

  def everyone?
    audience == 'everyone'
  end

  def cleanup_params
    transport_mean&.strip!
    self.transport_mean = nil unless %w[bus aereo].include?(transport_mean)
    set_slug_name!
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
      date,
      transport_mean
    ].compact.join('-')
  rescue NoMethodError
    nil
  end

  def should_generate_new_friendly_id?
    slug.blank? || home_team_id_changed? ||
      away_team_id_changed? || competition_id_changed? || date_changed? ||
      transport_mean_changed?
  end
end
