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
    bookable_from <= d && bookable_until >= d
  end

  def booked_by?(user_id)
    return false unless book_range?
    reservations.where(user_id: user_id).present?
  end
end
