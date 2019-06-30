# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  belongs_to :competition, inverse_of: :events

  scope :upcoming, -> { where('date >= ?', Time.zone.today) }

  has_many :reservations, inverse_of: :event, dependent: :destroy
  has_many :albums, inverse_of: :event, dependent: :nullify

  extend FriendlyId
  include BookableEvent
  include ReservationCsv

  AUDIENCE = %w[everyone preferred gold].freeze

  before_validation :cleanup_params
  before_save :check_availability

  after_update :send_availability_alert

  validates :custom_name, presence: true
  friendly_id :custom_name, use: %i[slugged history finders]

  class << self
    def sanitize(object)
      connection.quote(object)
    end

    def include_all
      includes(:competition, :home_team, :away_team, :reservations)
    end

    def transport_mean_class(transport_mean)
      return 'fa fa-bus' if transport_mean == 'bus'
      return 'fa fa-plane' if transport_mean == 'aereo'
    end
  end

  def to_s
    "#{home_team.name} vs #{away_team.name} #{transport_mean} (#{competition}, #{date})"
  end

  AUDIENCE.each do |aud|
    define_method("#{aud}?") { audience == aud }
    define_method("#{aud}!") { update(audience: aud) }
    define_method("was_#{aud}?") { audience_was == aud }
  end

  def cleanup_params
    transport_mean&.strip!
    self.transport_mean = nil unless %w[bus aereo].include?(transport_mean)
    set_slug_name!
  end

  def recalculate_seats!
    reservations_hash = reservations.group(:status).sum(
      :total_seats
    ).with_indifferent_access
    self.requested_seats = reservations_hash[:pending] || 0
    self.confirmed_seats = reservations_hash[:active] || 0
    self.rejected_seats = reservations_hash[:rejected] || 0
    self.available_seats = total_seats - confirmed_seats - requested_seats
  end

  def percentage_availability
    return 0 unless available_seats.positive?

    100 * available_seats / total_seats
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
    slug.blank? || will_save_change_to_home_team_id? ||
      will_save_change_to_away_team_id? || will_save_change_to_competition_id? ||
      will_save_change_to_date? || will_save_change_to_transport_mean?
  end

  def check_availability
    handle_seats_changes
    recalculate_seats! if will_save_change_to_total_seats?
  end

  def send_availability_alert
    return true unless saved_change_to_available_seats?

    ReservationMailer.overbooking(self).deliver_later unless available_seats.positive?
  end
end
