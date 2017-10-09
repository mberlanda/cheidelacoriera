# frozen_string_literal: true

class FansController < CrudController
  before_action :authenticate_user!
  self.permitted_attrs = %i[
    date_of_birth fidelity_card_no first_name last_name
    place_of_birth user_id
  ]
  self.search_columns = %i[
    date_of_birth fidelity_card_no first_name last_name
    place_of_birth user_id
  ]
end
