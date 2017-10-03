# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransportMean, type: :model do
  let!(:transport_mean) { FactoryGirl.create :transport_mean }

  context 'default transport_mean' do
    subject { transport_mean }

    it { should respond_to(:kind) }
    it { should respond_to(:company) }
    it { should respond_to(:phone_number) }
    it { should respond_to(:email) }
    it { should respond_to(:description) }
  end
end
