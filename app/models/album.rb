# frozen_string_literal: true

class Album < ApplicationRecord
  validates :title, presence: true
  validates :url, http_url: true, allow_nil: true

  belongs_to :event, inverse_of: :albums, optional: true

  def to_s
    title
  end
end
