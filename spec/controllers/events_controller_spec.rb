# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  render_views

  let!(:event) { FactoryBot.create(:event) }

  context 'when user is not logged in' do
    it 'can see upcoming events' do
      get :upcoming

      expect(response).to have_http_status(:ok)
    end

    it 'can see all events' do
      get :all

      expect(response).to have_http_status(:ok)
    end

    it 'can see event details' do
      get :details, params: { id: event.id }

      expect(response).to have_http_status(:ok)
    end

    it 'cannot see reservations for an event' do
      get :reservations, params: { id: event.id }

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'cannot export reservations csv for an event' do
      get :csv_reservations, params: { id: event.id }, format: :csv

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when active fan is logged in' do
    let(:active_fan) { FactoryBot.create(:user, role: :fan, status: :active) }

    before do
      sign_in active_fan
    end

    it 'can see event details without a reservation' do
      get :details, params: { id: event.id }

      expect(response).to have_http_status(:ok)
    end

    it 'can see event details with a reservation' do
      FactoryBot.create(:reservation, event: event, user: active_fan,
                                      fan_names: %w[Foo|Bar])

      get :details, params: { id: event.id }

      expect(response).to have_http_status(:ok)
    end

    it 'cannot see reservations for an event' do
      get :reservations, params: { id: event.id }

      expect(response).to redirect_to(root_url)
    end

    it 'cannot export reservations csv for an event' do
      get :csv_reservations, params: { id: event.id }, format: :csv

      expect(response).to redirect_to(root_url)
    end
  end

  context 'when admin is logged in' do
    let(:admin) { FactoryBot.create(:user, role: :admin, status: :active) }

    before do
      sign_in admin
    end

    it 'can see reservations for an event' do
      get :reservations, params: { id: event.id }

      expect(response).to have_http_status(:ok)
    end

    it 'can export reservations csv for an event' do
      get :csv_reservations, params: { id: event.id }, format: :csv

      expect(response).to have_http_status(:ok)
    end
  end
end
