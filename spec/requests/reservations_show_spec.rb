# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ReservationsController#show', type: :request do
  let(:competition1) { FactoryGirl.create(:competition) }
  let(:team_a) { FactoryGirl.create(:team) }
  let(:team_b) { FactoryGirl.create(:team) }
  let(:fan) { FactoryGirl.create(:user, role: :fan, status: :active) }
  let(:admin) { FactoryGirl.create(:user, role: :admin, status: :active) }
  let(:eventa) do
    FactoryGirl.create(
      :event, requested_seats: 0, confirmed_seats: 0,
              competition: competition1, home_team: team_a, away_team: team_b
    )
  end
  let!(:reservation1) do
    FactoryGirl.create(:reservation, user: fan, event: eventa, fan_names: %w[Foo|Bar])
  end

  before(:each) do
    Rails.cache.clear
  end

  it 'prevents 500s' do
    sign_in admin

    get "/reservations/#{reservation1.id}"

    expect(status).to eq(200)
  end
end
