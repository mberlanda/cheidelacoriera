# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ReservationsController#approve_all', type: :request do
  let(:admin) { FactoryGirl.create(:user, role: :admin, status: :active) }
  let(:event) { FactoryGirl.create(:event) }
  let!(:reservation_1) do
    FactoryGirl.create(
      :reservation,
      event: event,
      fan_names: %w[Foo|Bar]
    )
  end
  let!(:reservation_2) do
    FactoryGirl.create(
      :reservation,
      event: event,
      fan_names: %w[Bar|Baz]
    )
  end

  it 'prevents n+1 queries' do
    sign_in admin

    get '/reservations/approve_all', params: { event_id: event.id, slug: event.slug }
  end
end
