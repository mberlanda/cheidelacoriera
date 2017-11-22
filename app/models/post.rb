# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true
  validates :image_url, http_url: true, allow_nil: true
  validates :content, presence: true

  def to_s
    title
  end
end
