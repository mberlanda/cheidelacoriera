# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Crud::EventsController, type: :controller do
  context 'when user not logged' do
    it 'redirects to login page' do
      get :index
      aggregate_failures do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  context 'when active fan is logged in' do
    it 'redirects to home page' do
      sign_in FactoryBot.create(:user, role: :fan, status: :active)
      get :index
      aggregate_failures do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  context 'when admin is logged in' do
    let(:admin) { FactoryBot.create(:user, role: :admin, status: :active) }
    let(:event) { FactoryBot.create(:event) }

    before do
      FactoryBot.create(:reservation, event:, fan_names: %w[Foo|Bar])
      sign_in admin
    end

    it 'renders events list' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'shows a given event' do
      get :show, params: { id: event.id }

      expect(response).to have_http_status(:ok)
    end

    it 'renders event reservations list' do
      get :datatable_reservations, params: { id: event.id }, format: :json

      expect(response).to have_http_status(:ok)
    end
  end
end
