# frozen_string_literal: true

class Trip < ApplicationRecord
  belongs_to :event, inverse_of: :trips
  belongs_to :transport_mean, inverse_of: :trips

  def to_s
    "#{transport_mean.kind} #{id} - #{event}"
  end
end
