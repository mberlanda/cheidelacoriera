# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ReservationsController#datatable_index', type: :request do
  let(:competition1) { FactoryBot.create(:competition) }
  let(:competition2) { FactoryBot.create(:competition) }
  let(:team_a) { FactoryBot.create(:team) }
  let(:team_b) { FactoryBot.create(:team) }
  let(:team_c) { FactoryBot.create(:team) }
  let(:fan) { FactoryBot.create(:user, role: :fan, status: :active) }
  let(:admin) { FactoryBot.create(:user, role: :admin, status: :active) }
  let(:eventa) do
    FactoryBot.create(
      :event, requested_seats: 0, confirmed_seats: 0,
              competition: competition1, home_team: team_a, away_team: team_b
    )
  end
  let(:eventb) do
    FactoryBot.create(
      :event, requested_seats: 0, confirmed_seats: 0,
              competition: competition2, home_team: team_b, away_team: team_c
    )
  end
  let!(:reservation1) do
    FactoryBot.create(:reservation, user: fan, event: eventa, fan_names: %w[Foo|Bar])
  end
  let!(:reservation2) do
    FactoryBot.create(:reservation, user: fan, event: eventb, fan_names: %w[Foo|Bar])
  end
  let!(:reservation3) do
    FactoryBot.create(:reservation, user: admin, event: eventb, fan_names: %w[Foo|Bar])
  end

  before(:each) do
    Rails.cache.clear
  end

  it 'prevents n+1 queries' do
    sign_in admin

    get '/reservations/datatable_index.json'

    json_response = JSON.parse(response.body)
    expect(json_response['recordsTotal']).to eq(3)
  end
end
