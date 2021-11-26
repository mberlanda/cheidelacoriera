# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDecorator do
  it 'decorates without errors' do
    user = FactoryBot.create(:user)
    decorator = UserDecorator.new(user)

    expect(decorator.datatable_index).to eq(
      [
        "<a href=\"http://test.host/admin/users/#{user.id}\">#{user.email}</a>",
        user.first_name,
        user.last_name,
        decorator.status_field(user),
        decorator.role_field(user),
        user.phone_number,
        decorator.bool_field(user.newsletter),
        decorator.bool_field(user.mailing_listed),
        user.activation_date
      ]
    )
  end
end
