# frozen_string_literal: true

class TransportMean < ApplicationRecord
  validates :kind, presence: true, allow_blank: false
  validates :kind, uniqueness: { scope: :company }

  ROLES = %w[airplane bus train].freeze

  def to_s
    "#{kind} (#{company})"
  end
end
