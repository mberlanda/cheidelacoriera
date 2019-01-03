# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def increment_with_sql!(attribute, by = 1)
    change_with_sql(attribute, by)
  end

  def decrement_with_sql!(attribute, by = 1)
    change_with_sql(attribute, by * -1)
  end

  private

  def change_with_sql(attribute, by)
    unless attribute_names.include?(attribute.to_s)
      raise ArgumentError("Invalid attribute: #{attribute}")
    end

    new_val = (send(attribute) || 0) + by.to_i
    self.class.find(id).update(attribute => new_val)
    reload
  end
end
