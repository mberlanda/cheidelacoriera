# frozen_string_literal: true

class Fan < ApplicationRecord
  belongs_to :user, inverse_of: :fans

  validates :first_name, presence: true, allow_blank: false
  validates :last_name, presence: true, allow_blank: false

  def to_s
    [first_name, last_name].join(' ')
  end
end
