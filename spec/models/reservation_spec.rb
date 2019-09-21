# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, type: :model do
  before(:all) do
    @fan_names = %w[a_valid_fan another_fan]
  end

  # Need to find a better solution to clean up
  # after this test
  after(:all) do
    Reservation.delete_all
    Event.delete_all
    Team.delete_all
    User.delete_all
  end

  context 'default reservation' do
    subject { FactoryGirl.build :reservation }

    it { should respond_to(:total_seats) }
    it { should respond_to(:fan_names) }
    it { should respond_to(:notes) }
    it { should respond_to(:status) }
    it { should respond_to(:phone_number) }
    it { should respond_to(:user_id) }
    it { should respond_to(:event_id) }
    it { should respond_to(:mail_sent) }

    it 'should not be valid' do
      expect(subject.valid?).to be false
    end
  end

  context 'validate reservation' do
    let!(:event) { FactoryGirl.create(:event) }

    it '.check_fans if invalid' do
      expect do
        FactoryGirl.create :reservation, phone_number: default_phone_number
      end.to raise_exception(ActiveRecord::RecordInvalid)
    end

    it '.check_fans if valid' do
      actual = FactoryGirl.build(
        :reservation, fan_names: @fan_names, phone_number: default_phone_number
      )
      expect(actual.valid?).to be true
    end

    it '.process_fans! before save' do
      actual = FactoryGirl.build(:reservation, fan_names: @fan_names)
      expect(actual.total_seats).to be nil
      expect(actual.fan_names).to match_array(@fan_names)
    end

    it '.process_fans! after save' do
      actual = FactoryGirl.create(
        :reservation, fan_names: @fan_names, phone_number: default_phone_number
      )
      expect(actual.total_seats).to eq @fan_names.count
      expect(actual.fan_names).to match_array(@fan_names)
    end

    it '.assign_requested!' do
      expect do
        FactoryGirl.create(
          :reservation, event: event, fan_names: @fan_names,
                        phone_number: default_phone_number
        )
      end.to change { event.requested_seats }.by(@fan_names.size)
    end
  end

  context 'valid reservation' do
    before(:context) do
      @event = FactoryGirl.create(
        :event, confirmed_seats: 0, requested_seats: 0
      )
      @reservation = FactoryGirl.create(
        :reservation, event: @event, fan_names: @fan_names,
                      phone_number: default_phone_number
      )
    end

    it { expect(@reservation.status).to eq 'pending' }
    it { expect(@reservation.total_seats).to eq @fan_names.size }
    it { expect(@event.requested_seats).to eq @reservation.total_seats }
    it { expect(@event.confirmed_seats).to eq 0 }

    describe 'approved' do
      before(:context) do
        @prev_event = @event.dup
        @prev_reservation = @reservation.dup
        @reservation.approve
      end

      it { expect(@reservation.status).to eq 'active' }
      it { expect(@reservation.total_seats).to eq @fan_names.size }
      it { expect(@event.requested_seats).to eq 0 }
      it { expect(@event.confirmed_seats).to eq @reservation.total_seats }

      describe '.remove_requested! on destroy' do
        it 'pending' do
          event = @prev_reservation.event
          expect do
            @prev_reservation.destroy
          end.to change { event.requested_seats }.by(@prev_reservation.total_seats * -1)
        end

        it 'active' do
          event = @reservation.event
          expect do
            @reservation.destroy
          end.to change { event.confirmed_seats }.by(@reservation.total_seats * -1)
        end
      end
    end
  end

  context 'when approve_all' do
    it 'avoids n+1 queries' do
      event = FactoryGirl.create(:event)
      res1 = FactoryGirl.create(:reservation, fan_names: @fan_names, event: event)
      res2 = FactoryGirl.create(:reservation, fan_names: @fan_names, event: event)

      expect(Reservation.where(event_id: event.id).pending.count).to eq(2)

      Reservation.where(event_id: event.id).pending.approve_all

      aggregate_failures do
        expect(res1.reload.pending?).to be(false)
        expect(res2.reload.pending?).to be(false)
      end
    end
  end

  def default_phone_number
    @default_phone_number ||= FFaker::PhoneNumber.phone_number
  end
end
