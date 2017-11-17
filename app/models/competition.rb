# frozen_string_literal: true

class Competition < ApplicationRecord
  extend FriendlyId
  has_many :events, inverse_of: :competition, dependent: :destroy

  friendly_id :name, use: %i[slugged history finders]

  def to_s
    name
  end

  private

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
