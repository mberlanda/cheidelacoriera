# frozen_string_literal: true

module ReservationStatus
  extend ActiveSupport::Concern

  STATUSES = %w[active pending rejected].freeze

  STATUSES.each do |s|
    define_method("#{s}?") { status == s }
    define_method("#{s}!") { update(status: s) }
    define_method("was_#{s}?") { status_was == s }
  end

  module ClassMethods
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
end
