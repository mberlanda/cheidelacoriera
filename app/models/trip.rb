# frozen_string_literal: true

class Trip < ApplicationRecord
  belongs_to :event, inverse_of: :trips
  belongs_to :transport_mean, inverse_of: :trips, optional: true

  validates :name, presence: true, allow_blank: false

  class << self
    def bookable(d = Date.today)
      where('bookable_from <= ? and bookable_until >= ?', d, d)
    end
  end

  def to_s
    "#{name} #{transport_mean_kind} - #{event}"
  end

  def transport_mean_kind
    transport_mean ? transport_mean.kind : ''
  end
end
