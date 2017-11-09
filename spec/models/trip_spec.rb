# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trip, type: :model do
  let!(:trip) { FactoryGirl.build :trip }

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
    it { should respond_to(:name) }
  end

  context '.bookable' do
    before do
      DatabaseCleaner.clean_with(:truncation)
      @trip1 = FactoryGirl.create(
        :trip,
        bookable_from: Date.today,
        bookable_until: Date.today + 5.days
      )
      @trip2 = FactoryGirl.create(
        :trip,
        bookable_from: Date.today - 5.days,
        bookable_until: Date.today + 1.day
      )
    end

    it 'uses by default Date.today' do
      actual = Trip.all.select(&:bookable)
      expect(actual.count).to eq(2)
      expect(actual).to match_array([@trip1, @trip2])
    end

    it 'can use custom date' do
      actual = Trip.all.select do |t|
        t.bookable(Date.today - 2.days)
      end
      expect(actual.count).to eq(1)
      expect(actual).to match_array([@trip2])
    end
  end
end
