# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :user, inverse_of: :reservations
  belongs_to :event, inverse_of: :reservations

  validates :phone_number, presence: true, allow_blank: false,
                           format: { with: /\A[x\d\(\)\s\-\.]{5,}\z/ }
  validate :check_fans
  validates :notes, length: { maximum: 150 }

  before_save :process_fans!
  before_create :set_default_status!
  after_create :assign_requested!

  scope :pending, ->() { where(status: :pending) }
  delegate :event, :event_id, to: :trip

  def to_s
    "#{user} #{trip}"
  end

  class << self
    def approve_all
      all.find_each(&:approve)
    end
  end

  def approve
    return unless status == 'pending'
    self.status = 'active'
    trip.decrement_with_sql!(:requested_seats, total_seats)
    trip.decrement_with_sql!(:available_seats, total_seats)
    trip.increment_with_sql!(:reserved_seats, total_seats)
    save!
  end

  private

  def check_fans
    return true unless fan_ids.empty?
    errors.add(:fan_ids, I18n.t('errors.messages.blank'))
  end

  def process_fans!
    self.fan_names = ['fan_refactoring'] * fan_ids.count
    self.total_seats = fan_ids.count
  end

  def set_default_status!
    self.status = 'pending'
  end

  def assign_requested!
    trip.increment_with_sql!(:requested_seats, total_seats)
  end
end
