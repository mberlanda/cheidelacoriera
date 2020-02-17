# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Crud::UsersController#datatable_index', type: :request do
  let(:admin) { FactoryGirl.create(:user, role: :admin, status: :active) }

  it 'uses a different implementation preventing memory bloating' do
    n = 2
    n.times { FactoryGirl.create(:user) }

    sign_in admin

    get '/admin/users/datatable_index.json'

    payload = JSON.parse(response.body)
    aggregate_failures do
      expect(payload['draw']).to eq(0)
      expect(payload['recordsFiltered']).to eq(n + 1)
      expect(payload['recordsTotal']).to eq(n + 1)
      expect(payload['data'].map(&:first)).to match_array(
        User.select(:id, :email).all.map do |u|
          "<a href=\"/admin/users/#{u.id}\">#{u.email}</a>"
        end
      )
    end
  end
end
