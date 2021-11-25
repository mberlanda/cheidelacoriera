# frozen_string_literal: true

require 'rails_helper'

FANS_MAP = {
  active_fan: FactoryBot.create(:user, role: :fan, status: :active),
  pending_fan: FactoryBot.create(:user, role: :fan, status: :pending),
  rejected_fan: FactoryBot.create(:user, role: :fan, status: :rejected)
}.freeze

RSpec.describe ReservationsController, type: :controller do
  let!(:admin) { FactoryBot.create(:user, role: :admin, status: :active) }
  let!(:event) { FactoryBot.create(:event) }

  def pending_fan
    @pending_fan ||= FactoryBot.create(:user, role: :fan, status: :pending)
  end

  def active_fan
    @active_fan ||= FactoryBot.create(:user, role: :fan, status: :active)
  end

  def rejected_fan
    @rejected_fan ||= FactoryBot.create(:user, role: :fan, status: :rejected)
  end

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
    def create_fans_proc
      @create_fans_proc ||= ->(h) { "#{h[:last_name]}|#{h[:first_name]}" }
    end

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
      FANS_MAP.each do |fan_status, fan|
        it "redirects #{fan_status} to homepage" do
          sign_in fan
          post :create, params: valid_create_reservation_params(fan, event)

          # redirect to the request.referral
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end
    context 'when admin' do
      before(:each) { sign_in admin }
      it 'creates and redirects to show page an admin with valid inputs' do
        post :create, params: valid_create_reservation_params(admin, event)
        assert_reservation_created(response)
      end

      it 'redirects to new_reservation an admin with validation errors' do
        empty_fans = ->(_) { nil }
        params = valid_reservation_params(active_fan, event, fans_proc: empty_fans)
        post :create, params: params

        assert_form_validation_errors(response)
      end

      it 'can create reservations on behalf of other users' do
        post :create, params: valid_create_reservation_params(active_fan, event)

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

      it 'returns bad request if tries to create reservations on behalf of other users' do
        params = valid_reservation_params(pending_fan, event)
        post :form_create, params: params

        expect(response).to have_http_status(400)
      end

      it 'returns 400 with validation errors if reservation is not valid' do
        empty_fans = ->(_) { nil }
        params = valid_reservation_params(active_fan, event, fans_proc: empty_fans)
        post :form_create, params: params

        expect(response).to have_http_status(400)
        json_response = JSON.parse(response.body)

        expect(json_response.keys).to include('errors')
        expect(json_response['errors'].keys).to include('fan_names')
      end
    end
  end
end
