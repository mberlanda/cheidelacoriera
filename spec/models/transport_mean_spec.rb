# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransportMean, type: :model do
  let!(:transport_mean) { FactoryBot.create :transport_mean }

  context 'default transport_mean' do
    subject { transport_mean }

    it { is_expected.to respond_to(:kind) }
    it { is_expected.to respond_to(:company) }
    it { is_expected.to respond_to(:phone_number) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:description) }
  end
end
