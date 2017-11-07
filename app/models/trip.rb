# frozen_string_literal: true

class Trip < ApplicationRecord
  belongs_to :event, inverse_of: :trip
  belongs_to :transport_mean, inverse_of: :trips, optional: true

  validates :name, presence: true, allow_blank: false

  has_many :reservations, inverse_of: :trip, dependent: :destroy

  def bookable(d = Date.today)
    return false unless bookable_from && bookable_until
    bookable_from <= d && bookable_until >= d
  end

  def to_s
    "#{name} #{transport_mean_kind} - #{event}"
  end

  def transport_mean_kind
    transport_mean ? transport_mean.kind : ''
  end
end
