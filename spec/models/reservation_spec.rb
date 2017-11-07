# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, type: :model do
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

  context 'valid reservation' do
    let(:phone_number) { FFaker::PhoneNumber.phone_number }
    let(:fans) { [FactoryGirl.create(:fan), FactoryGirl.create(:fan)] }
    let(:fan_ids) { fans.map(&:id) }

    it '.check_fans if invalid' do
      expect do
        FactoryGirl.create :reservation, phone_number: phone_number
      end.to raise_exception(ActiveRecord::RecordInvalid)
    end

    it '.check_fans if valid' do
      actual = FactoryGirl.build(:reservation,
                                 fan_ids: fan_ids, phone_number: phone_number)
      puts phone_number
      expect(actual.valid?).to be true
    end

    it '.process_fans! before save' do
      actual = FactoryGirl.build(:reservation, fan_ids: fan_ids)
      puts phone_number
      expect(actual.total_seats).to be nil
      expect(actual.fan_names).to eq([])
    end

    it '.process_fans! after save' do
      puts phone_number
      actual = FactoryGirl.create(:reservation,
                                  fan_ids: fan_ids, phone_number: phone_number)
      expect(actual.total_seats).to eq fans.count
      expect(actual.fan_names).to match_array(fans.map(&:to_s))
    end
  end
end
