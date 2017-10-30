# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trip, type: :model do
  let!(:trip) { FactoryGirl.create :trip }

  context 'default trip' do
    subject { trip }

    it { should respond_to(:total_seats) }
    it { should respond_to(:available_seats) }
    it { should respond_to(:requested_seats) }
    it { should respond_to(:reserved_seats) }
    it { should respond_to(:event) }
    it { should respond_to(:transport_mean) }
    it { should respond_to(:bookable_from) }
    it { should respond_to(:bookable_until) }
    it { should respond_to(:poster_url) }
    it { should respond_to(:name) }
  end
end
