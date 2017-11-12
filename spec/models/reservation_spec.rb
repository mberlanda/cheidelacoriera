# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, type: :model do
  before(:all) do
    @fans = [
      OpenStruct.new(id: 1, name: 'fan_refactoring'),
      OpenStruct.new(id: 2, name: 'fan_refactoring')
    ]
    @fan_ids = @fans.map(&:id)
  end

  context 'default reservation' do
    subject { FactoryGirl.build :reservation }

    it { should respond_to(:total_seats) }
    it { should respond_to(:fan_ids) }
    it { should respond_to(:fan_names) }
    it { should respond_to(:notes) }
    it { should respond_to(:status) }
    it { should respond_to(:phone_number) }
    it { should respond_to(:user_id) }
    it { should respond_to(:trip_id) }

    it 'should not be valid' do
      expect(subject.valid?).to be false
    end
  end

  context 'validate reservation' do
    let!(:trip) { FactoryGirl.create(:trip) }

    it '.check_fans if invalid' do
      expect do
        FactoryGirl.create :reservation, phone_number: default_phone_number
      end.to raise_exception(ActiveRecord::RecordInvalid)
    end

    it '.check_fans if valid' do
      actual = FactoryGirl.build(
        :reservation, fan_ids: @fan_ids, phone_number: default_phone_number
      )
      expect(actual.valid?).to be true
    end

    it '.process_fans! before save' do
      actual = FactoryGirl.build(:reservation, fan_ids: @fan_ids)
      expect(actual.total_seats).to be nil
      expect(actual.fan_names).to eq([])
    end

    it '.process_fans! after save' do
      actual = FactoryGirl.create(
        :reservation, fan_ids: @fan_ids, phone_number: default_phone_number
      )
      expect(actual.total_seats).to eq @fans.count
      expect(actual.fan_names).to match_array(@fans.map(&:name))
    end

    it '.assign_requested!' do
      expect do
        FactoryGirl.create(
          :reservation, trip: trip, fan_ids: @fan_ids,
                        phone_number: default_phone_number
        )
      end.to change { trip.requested_seats }.by(@fan_ids.size)
    end
  end

  context 'valid reservation' do
    before(:context) do
      @trip = FactoryGirl.create(
        :trip, total_seats: 100, available_seats: 100,
               requested_seats: 0, reserved_seats: 0
      )
      @reservation = FactoryGirl.create(
        :reservation, trip: @trip, fan_ids: @fan_ids,
                      phone_number: default_phone_number
      )
    end

    it { expect(@reservation.status).to eq 'pending' }
    it { expect(@reservation.total_seats).to eq @fan_ids.size }
    it { expect(@trip.requested_seats).to eq @reservation.total_seats }
    it { expect(@trip.available_seats).to eq @trip.total_seats }
    it { expect(@trip.reserved_seats).to eq 0 }

    describe 'approved' do
      before(:context) do
        @prev_trip = @trip.dup
        @reservation.approve
      end

      it { expect(@reservation.status).to eq 'active' }
      it { expect(@reservation.total_seats).to eq @fan_ids.size }
      it { expect(@trip.requested_seats).to eq 0 }
      it do
        expect(@trip.available_seats).to eq(
          @prev_trip.total_seats - @reservation.total_seats
        )
      end
      it { expect(@trip.reserved_seats).to eq @reservation.total_seats }
    end
  end

  def default_phone_number
    @default_phone_number ||= FFaker::PhoneNumber.phone_number
  end
end