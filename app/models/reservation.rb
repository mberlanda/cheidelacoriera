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

  STATUSES = %w[active pending rejected].freeze

  def to_s
    "#{user} #{event}"
  end

  class << self
    def approve_all
      all.find_each(&:approve)
    end
  end

  def approve
    return unless status == 'pending'
    self.status = 'active'
    event.decrement_with_sql!(:requested_seats, total_seats)
    event.increment_with_sql!(:confirmed_seats, total_seats)
    save!
  end

  private

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
