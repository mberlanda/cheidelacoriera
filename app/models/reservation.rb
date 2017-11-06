# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :user, inverse_of: :reservations
  belongs_to :trip, inverse_of: :reservations

  validates :phone_number, presence: true, allow_blank: false
  validate :check_fans
  before_save :process_fans!

  private

  def check_fans
    return true unless fan_ids.empty?
    errors.add(:fan_ids, 'Please select at least one fan for this reservation.')
  end

  def process_fans!
    self.fan_names = Fan.where(id: fan_ids).map(&:to_s)
    self.total_seats = fan_ids.count
  end
end
