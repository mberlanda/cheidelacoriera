class Fan < ApplicationRecord
  belongs_to :user, inverse_of: :fans

end
