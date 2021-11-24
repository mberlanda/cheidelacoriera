# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  let!(:admin) { FactoryBot.create(:user, role: :admin, status: :active) }
  let!(:pending_fan) { FactoryBot.create(:user, role: :fan, status: :pending) }
  let!(:active_fan) { FactoryBot.create(:user, role: :fan, status: :active) }
  let!(:rejected_fan) { FactoryBot.create(:user, role: :fan, status: :rejected) }
  let!(:event) { FactoryBot.create(:event) }

  def valid_reservation_params(user, event, fans_proc: ->(x) { x })
    {
      reservation: {
        event_id: event.id,
        fan_names: [
          { first_name: 'Foo', last_name: 'Bar' },
          { first_name: 'Baz', last_name: 'Bar' }
        ].map(&fans_proc),
        fans_count: 2,
        notes: '',
        phone_number: user.phone_number,
        user_id: user.id
      }
    }
  end

  describe 'POST#create' do
    let(:create_fans_proc) { ->(h) { "#{h[:last_name]}|#{h[:first_name]}" } }

    def valid_create_reservation_params(user, event)
      valid_reservation_params(user, event, fans_proc: create_fans_proc)
    end

    def assert_unpermitted_action(response)
      expect(response).to redirect_to(root_url)
    end

    def assert_reservation_created(response)
      expect(response).to redirect_to(reservation_url(Reservation.last.id))
    end

    def assert_form_validation_errors(response)
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end

    context 'when user is not an admin' do
      it 'redirects to another page a pending_fan' do
        sign_in pending_fan
        post :create, params: valid_create_reservation_params(pending_fan, event)

        assert_unpermitted_action(response)
      end

      it 'redirects to another page a rejected_fan' do
        sign_in rejected_fan
        post :create, params: valid_create_reservation_params(rejected_fan, event)

        assert_unpermitted_action(response)
      end

      it 'creates and redirects to another page an active_fan' do
        sign_in active_fan
        post :create, params: valid_create_reservation_params(active_fan, event)

        assert_reservation_created(response)
      end

      it 'redirects to new reservation an active_fan with validation errors' do
        sign_in active_fan
        empty_fans = ->(_) { nil }
        params = valid_reservation_params(active_fan, event, fans_proc: empty_fans)
        post :create, params: params

        assert_form_validation_errors(response)
      end

      it 'FIXME: can create reservations for another user playing around with postman' do
        sign_in active_fan
        post :create, params: valid_create_reservation_params(pending_fan, event)

        assert_reservation_created(response)
      end
    end
  end
  describe 'POST#form_create' do
    context 'when a user is a fan' do
      before(:each) do
        sign_in active_fan
      end
      it 'creates a reservation with valid input' do
        reservation_count_before = Reservation.count
        params = valid_reservation_params(active_fan, event)
        post :form_create, params: params

        expect(Reservation.count).to eq(reservation_count_before + 1)
        expect(response).to have_http_status(200)
      end
    end
  end
end
