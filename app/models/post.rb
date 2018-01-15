# frozen_string_literal: true

class Post < ApplicationRecord
  extend FriendlyId
  validates :title, presence: true
  validates :image_url, http_url: true, allow_nil: true, allow_blank: true
  # validates :content, presence: true

  after_initialize :set_defaults, unless: :persisted?
  friendly_id :title, use: %i[slugged history finders]

  def to_s
    title
  end

  private

  def set_defaults
    self.date ||= Date.today
  end

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title?
  end
end
