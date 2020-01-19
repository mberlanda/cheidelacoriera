# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ReservationsController#approve_all', type: :request do
  let(:fan) { FactoryBot.create(:user, role: :fan, status: :active) }
  let(:admin) { FactoryBot.create(:user, role: :admin, status: :active) }
  let(:event) do
    FactoryBot.create(:event, requested_seats: 0, confirmed_seats: 0)
  end

  context 'when logged user is not admin' do
    it 'redirects to another page' do
      sign_in fan

      get '/reservations/approve_all', params: { event_id: event.id, slug: event.slug }

      expect(response.status).to eq(302)
    end
  end

  context 'when no pending reservation' do
    it 'does not change anything' do
      sign_in admin

      aggregate_failures do
        expect(event.confirmed_seats).to eq(0)
        expect(event.requested_seats).to eq(0)
      end

      get '/reservations/approve_all', params: { event_id: event.id, slug: event.slug }

      aggregate_failures do
        expect(event.reload.confirmed_seats).to eq(0)
        expect(event.reload.requested_seats).to eq(0)
      end
    end
  end

  context 'when a single pending reservation' do
    let!(:reservation_1) do
      FactoryBot.create(
        :reservation,
        event: event,
        fan_names: %w[Foo|Bar]
      )
    end

    it 'prevents n+1 queries' do
      sign_in admin

      aggregate_failures do
        expect(reservation_1.status).to eq('pending')
        expect(event.confirmed_seats).to eq(0)
        expect(event.requested_seats).to eq(1)
      end

      get '/reservations/approve_all', params: { event_id: event.id, slug: event.slug }

      aggregate_failures do
        expect(reservation_1.reload.status).to eq('active')
        expect(event.reload.confirmed_seats).to eq(1)
        expect(event.reload.requested_seats).to eq(0)
      end
    end
  end

  context 'when multiple pending reservations' do
    let!(:reservation_1) do
      FactoryBot.create(
        :reservation,
        event: event,
        fan_names: %w[Foo|Bar]
      )
    end
    let!(:reservation_2) do
      FactoryBot.create(
        :reservation,
        event: event,
        fan_names: %w[Bar|Baz Bat|Man]
      )
    end

    it 'prevents n+1 queries' do
      sign_in admin

      aggregate_failures do
        expect(reservation_1.status).to eq('pending')
        expect(reservation_2.status).to eq('pending')
        expect(event.confirmed_seats).to eq(0)
        expect(event.requested_seats).to eq(3)
      end

      get '/reservations/approve_all', params: { event_id: event.id, slug: event.slug }

      aggregate_failures do
        expect(reservation_1.reload.status).to eq('active')
        expect(reservation_2.reload.status).to eq('active')
        expect(event.reload.confirmed_seats).to eq(3)
        expect(event.reload.requested_seats).to eq(0)
      end
    end
  end
end
