# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ReservationsController#status', type: :request do
  let(:competition1) { FactoryBot.create(:competition) }
  let(:team_a) { FactoryBot.create(:team) }
  let(:team_b) { FactoryBot.create(:team) }
  let(:fan) { FactoryBot.create(:user, role: :fan, status: :active) }
  let(:another_fan) { FactoryBot.create(:user, role: :fan, status: :active) }
  let(:admin) { FactoryBot.create(:user, role: :admin, status: :active) }
  let(:eventa) do
    FactoryBot.create(
      :event, requested_seats: 0, confirmed_seats: 0,
              competition: competition1, home_team: team_a, away_team: team_b
    )
  end
  let!(:reservation1) do
    FactoryBot.create(:reservation, user: fan, event: eventa, fan_names: %w[Foo|Bar])
  end

  before do
    Rails.cache.clear
  end

  context 'when a fan is logged in' do
    it 'shows the fan reservation status' do
      sign_in fan

      get "/reservations/#{reservation1.id}/status"

      expect(status).to eq(200)
      expect(response).to render_template(:status)
    end
  end

  context 'when an admin is logged in' do
    it 'shows the fan reservation status' do
      sign_in admin

      get "/reservations/#{reservation1.id}/status"

      expect(status).to eq(200)
      expect(response).to render_template(:status)
    end
  end

  context 'when another fan is logged in' do
    it 'shows the fan reservation status' do
      sign_in another_fan

      get "/reservations/#{reservation1.id}/status"

      expect(status).to eq(200)
      expect(response).to render_template(:status)
    end
  end
end
