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
    return false unless available_seats.positive?
    bookable_period?(d)
  end

  def bookable_period?(d = Date.today)
    return false unless book_range?
    bookable_from <= d && bookable_until >= d
  end

  def booked_by?(user_id)
    return false unless book_range?
    reservations.where(user_id: user_id).present?
  end

  # This is executed in a before_save hook
  # https://github.com/rails/rails/pull/25337#issuecomment-225166796
  %i[confirmed_seats requested_seats rejected_seats].each do |seats|
    define_method("#{seats}_delta") do
      send(seats) - send("#{seats}_in_database")
    end
  end

  def handle_seats_changes
    decrease_availability!(confirmed_seats_delta) if will_save_change_to_confirmed_seats?
    decrease_availability!(requested_seats_delta) if will_save_change_to_requested_seats?
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
