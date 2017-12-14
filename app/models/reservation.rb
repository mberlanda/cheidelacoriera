# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :user, inverse_of: :reservations
  belongs_to :event, inverse_of: :reservations

  validates :phone_number, presence: true, allow_blank: false,
                           format: { with: /\A[x\d\(\)\s\-\.]{5,}\z/ }
  before_validation :process_fans!

  validate :check_fans
  validates :notes, length: { maximum: 150 }
  validates :user_id, presence: true, allow_nil: false
  validates :event_id, presence: true, allow_nil: false, uniqueness: { scope: :user_id }

  before_create :set_default_status!
  after_create :assign_requested!
  before_destroy :remove_requested!

  scope :pending, ->() { where(status: :pending) }
  belongs_to :event, inverse_of: :reservations

  after_update :handle_statuses

  STATUSES = %w[active pending rejected].freeze

  STATUSES.each do |s|
    define_method("#{s}?") { status == s }
    define_method("#{s}!") { update(status: s) }
  end

  def to_s
    "#{user} #{event}"
  end

  class << self
    def approve_all
      all.find_each(&:approve)
    end
  end

  def approve
    return unless pending?
    active!
  end

  def handle_statuses
    return unless status_changed?
    handle_active if active?
    handle_pending if pending?
    handle_rejected if rejected?
  end

  private

  def handle_active
    event.increment_with_sql!(:confirmed_seats, total_seats)
    decrement_requested if status_was == 'pending'
    decrement_rejected if status_was == 'rejected'
    ReservationMailer.approved(Reservation.includes(:user, :event).find(id)).deliver_later
  end

  def handle_pending
    event.increment_with_sql!(:requested_seats, total_seats)
    decrement_confirmed if status_was == 'active'
    decrement_rejected if status_was == 'rejected'
  end

  def handle_rejected
    event.increment_with_sql!(:rejected_seats, total_seats)
    decrement_requested if status_was == 'pending'
    decrement_confirmed if status_was == 'active'
    ReservationMailer.rejected(Reservation.includes(:user, :event).find(id)).deliver_later
  end

  def decrement_confirmed
    event.decrement_with_sql!(:confirmed_seats, total_seats)
  end

  def decrement_rejected
    event.decrement_with_sql!(:rejected_seats, total_seats)
  end

  def decrement_requested
    event.decrement_with_sql!(:requested_seats, total_seats)
  end

  def check_fans
    return true unless fan_names.empty?
    errors.add(:fan_names, I18n.t('errors.messages.blank'))
  end

  def process_fans!
    self.fan_names = fan_names.to_a.reject { |f| f.blank? || f.size < 6 }
    self.total_seats = fan_names.count
  end

  def set_default_status!
    self.status = 'pending'
  end

  def assign_requested!
    event.increment_with_sql!(:requested_seats, total_seats)
  end

  def remove_requested!
    event.decrement_with_sql!(:requested_seats, total_seats) if status == 'pending'
    event.decrement_with_sql!(:confirmed_seats, total_seats) if status == 'active'
  end
end
