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
  scope :for_event, ->(event_id) { where(event_id: event_id) }
  belongs_to :event, inverse_of: :reservations

  after_update :handle_updates
  # after_destroy :handle_destroy

  STATUSES = %w[active pending rejected].freeze

  STATUSES.each do |s|
    define_method("#{s}?") { status == s }
    define_method("#{s}!") { update(status: s) }
    define_method("was_#{s}?") { status_was == s }
  end

  def to_s
    "#{user} #{event}"
  end

  class << self
    def includes_all
      includes(:user, :event)
    end

    def approve_all
      all.find_each(&:approve)
    end
  end

  def approve
    return unless pending?
    active!
  end

  def handle_updates
    handle_total_seats
    handle_statuses
  end

  def handle_statuses
    return unless status_changed?
    handle_active if active?
    handle_pending if pending?
    handle_rejected if rejected?
  end

  def handle_total_seats
    return unless total_seats_changed?
    seats_diff = total_seats_was - total_seats
    decrement_confirmed(seats_diff) if was_active?
    decrement_requested(seats_diff) if was_pending?
    decrement_rejected(seats_diff) if was_rejected?
  end

  def handle_destroy
    decrement_confirmed(total_seats_was) if was_active?
    decrement_requested(total_seats_was) if was_pending?
    decrement_rejected(total_seats_was) if was_rejected?
  end

  private

  def handle_active
    event.increment_with_sql!(:confirmed_seats, total_seats)
    decrement_requested if was_pending?
    decrement_rejected if was_rejected?
    ReservationMailer.approved(self).deliver_later
  end

  def handle_pending
    event.increment_with_sql!(:requested_seats, total_seats)
    decrement_confirmed if was_active?
    decrement_rejected if was_rejected?
  end

  def handle_rejected
    event.increment_with_sql!(:rejected_seats, total_seats)
    decrement_requested if was_pending?
    decrement_confirmed if was_active?
    ReservationMailer.rejected(Reservation.includes_all.find(id)).deliver_later
  end

  def decrement_confirmed(amount = total_seats)
    event.decrement_with_sql!(:confirmed_seats, amount)
  end

  def decrement_rejected(amount = total_seats)
    event.decrement_with_sql!(:rejected_seats, amount)
  end

  def decrement_requested(amount = total_seats)
    event.decrement_with_sql!(:requested_seats, amount)
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
