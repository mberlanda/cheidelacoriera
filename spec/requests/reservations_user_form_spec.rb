# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ReservationsController#status', type: :request do
  let(:fan) { FactoryBot.create(:user, role: :fan, status: :active) }
  let(:another_fan) { FactoryBot.create(:user, role: :fan, status: :active) }
  let(:admin) { FactoryBot.create(:user, role: :admin, status: :active) }
  let(:event) do
    FactoryBot.create(:event, requested_seats: 0, confirmed_seats: 0)
  end
  before(:each) do
    Rails.cache.clear
  end

  context 'when a user is rejected' do
    it 'renders rejected static page' do
      fan.rejected!
      sign_in fan

      get '/reservations/user_form', params: { event_id: event.id }

      expect(status).to eq(200)
      expect(response).to render_template('reservations/rejected_user')
    end
  end

  context 'when a user is pending' do
    it 'renders pending static page' do
      fan.pending!
      sign_in fan

      get '/reservations/user_form', params: { event_id: event.id }

      expect(status).to eq(200)
      expect(response).to render_template('reservations/pending_user')
    end
  end

  context 'when the event is not bookable' do
    it 'renders not bookable static page' do
      allow(event).to receive(:book_range?).and_return(false)
      sign_in fan

      get '/reservations/user_form', params: { event_id: event.id }

      expect(status).to eq(200)
      expect(response).to render_template('reservations/no_user_form')
    end
  end

  context 'when a user has already booked' do
    it 'redirects to reservation status' do
      allow(event).to receive(:book_range?).and_return(true)
      reservation = FactoryBot.create(:reservation, user_id: fan.id, event_id: event.id,
                                                    fan_names: %w[Foo|Bar])
      sign_in fan

      get '/reservations/user_form', params: { event_id: event.id }

      expect(status).to eq(302)
      expect(response).to redirect_to("/reservations/#{reservation.id}/status")
    end
  end

  context 'when a user cannot book an available event' do
    it 'renders not bookable static page' do
      allow(event).to receive(:book_range?).and_return(true)
      allow(fan).to receive(:can_book?).with(event).and_return(false)

      sign_in fan

      get '/reservations/user_form', params: { event_id: event.id }

      expect(status).to eq(200)
      expect(response).to render_template('reservations/no_user_form')
    end
  end

  context 'when a user can book an available event' do
    it 'renders not bookable static page' do
      allow(event).to receive(:book_range?).and_return(true)
      allow(fan).to receive(:can_book?).with(event).and_return(true)

      sign_in fan

      get '/reservations/user_form', params: { event_id: event.id }

      expect(status).to eq(200)
      expect(response).to render_template('reservations/user_form')
    end
  end
end
