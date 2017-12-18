# frozen_string_literal: true

module BookableEvent
  extend ActiveSupport::Concern

  module ClassMethods
    def bookable(d = Date.today)
      where('bookable_from <= ? and bookable_until >= ?', d, d)
    end
  end

  def book_range?
    bookable_from && bookable_until
  end

  def bookable?(d = Date.today)
    return false unless book_range?
    return false unless available_seats.positive?
    bookable_from <= d && bookable_until >= d
  end

  def booked_by?(user_id)
    return false unless book_range?
    reservations.where(user_id: user_id).present?
  end

  %i[confirmed_seats requested_seats rejected_seats].each do |seats|
    define_method("#{seats}_delta") do
      send(seats) - send("#{seats}_was")
    end
  end

  def handle_seats_changes
    decrease_availability!(confirmed_seats_delta) if confirmed_seats_changed?
    decrease_availability!(requested_seats_delta) if requested_seats_changed?
    # increase_availability!(rejected_seats_delta) if rejected_seats_changed?
  end

  private

  def decrease_availability!(amount)
    # decrement_with_sql!(:available_seats, amount)
    self.available_seats -= amount
  end

  def increase_availability!(amount)
    # increment_with_sql!(:available_seats, amount)
    self.available_seats += amount
  end
end
