# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :user, inverse_of: :reservations
  belongs_to :trip, inverse_of: :reservations

  validates :phone_number, presence: true, allow_blank: false,
                           format: { with: /\A[x\d\(\)\s\-\.]{5,}\z/ }
  validate :check_fans

  before_save :process_fans!
  before_create :set_default_status!

  private

  def check_fans
    return true unless fan_ids.empty?
    errors.add(:fan_ids, I18n.t('errors.messages.blank'))
  end

  def process_fans!
    self.fan_names = Fan.where(id: fan_ids).map(&:to_s)
    self.total_seats = fan_ids.count
  end

  def set_default_status!
    self.status = 'pending'
  end
end
