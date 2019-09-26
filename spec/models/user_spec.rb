# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'default user' do
    subject! { FactoryGirl.build :user }

    it { should respond_to(:email) }
    it { should respond_to(:encrypted_password) }
    it { should respond_to(:role) }
    it { should respond_to(:status) }
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:date_of_birth) }
    it { should respond_to(:place_of_birth) }
    it { should respond_to(:phone_number) }
    it { should respond_to(:newsletter) }
    it { should respond_to(:activation_date) }
    it { should respond_to(:can_book?) }
    it { should respond_to(:can_see_availability?) }

    it 'has default role' do
      expect(subject.role).to eq('fan')
    end
    it 'has default status' do
      expect(subject.status).to eq('pending')
    end
  end
  context 'admin user' do
    let(:fan_user) { FactoryGirl.build(:user, role: 'fan') }
    let(:admin_user) { FactoryGirl.build(:user, role: 'admin') }

    subject { admin_user }

    it 'admin?' do
      expect(subject.admin?).to be(true)
    end
  end

  context 'fan user' do
    let(:fan_user) { FactoryGirl.build(:user, role: 'fan') }
    let(:admin_user) { FactoryGirl.build(:user, role: 'admin') }

    subject { fan_user }

    it 'admin?' do
      expect(subject.admin?).to be(false)
    end
  end

  context 'can_book?' do
    let!(:active_attrs) do
      {
        bookable_from: Date.new(2018, 12, 31),
        bookable_until: Date.new(3018, 12, 31),
        available_seats: 10
      }
    end
    let!(:expired_attrs) do
      { bookable_from: nil, bookable_until: Date.new(2018, 12, 31), available_seats: 10 }
    end

    let!(:expired_event) do
      FactoryGirl.build(:event, audience: 'everyone', **expired_attrs)
    end
    let!(:public_event) do
      FactoryGirl.build(:event, audience: 'everyone', **active_attrs)
    end
    let!(:preferred_event) do
      FactoryGirl.build(:event, audience: 'preferred', **active_attrs)
    end
    let!(:gold_event) do
      FactoryGirl.build(:event, audience: 'gold', **active_attrs)
    end

    let!(:fan_user) do
      FactoryGirl.build(:user, role: 'fan', status: 'active')
    end
    let!(:preferred_user) do
      FactoryGirl.build(:user, role: 'preferred', status: 'active')
    end
    let!(:gold_user) do
      FactoryGirl.build(:user, role: 'gold', status: 'active')
    end
    let(:admin_user) do
      FactoryGirl.build(:user, role: 'admin', status: 'active')
    end

    it 'fan_user only everyone' do
      aggregate_failures do
        expect(fan_user.can_book?(public_event)).to be(true)
        expect(fan_user.can_book?(preferred_event)).to be(false)
        expect(fan_user.can_book?(gold_event)).to be(false)
        expect(fan_user.can_book?(expired_event)).to be(false)
        expect(fan_user.can_see_availability?).to be(false)
      end
    end

    it 'preferred_user only everyone and preferred' do
      aggregate_failures do
        expect(preferred_user.can_book?(public_event)).to be(true)
        expect(preferred_user.can_book?(preferred_event)).to be(true)
        expect(preferred_user.can_book?(gold_event)).to be(false)
        expect(preferred_user.can_book?(expired_event)).to be(false)
        expect(preferred_user.can_see_availability?).to be(true)
      end
    end

    it 'gold_user all bookable events' do
      aggregate_failures do
        expect(gold_user.can_book?(public_event)).to be(true)
        expect(gold_user.can_book?(preferred_event)).to be(true)
        expect(gold_user.can_book?(gold_event)).to be(true)
        expect(gold_user.can_book?(expired_event)).to be(false)
        expect(gold_user.can_see_availability?).to be(true)
      end
    end

    it 'admin_user all bookable events' do
      aggregate_failures do
        expect(admin_user.can_book?(public_event)).to be(true)
        expect(admin_user.can_book?(preferred_event)).to be(true)
        expect(admin_user.can_book?(gold_event)).to be(true)
        expect(admin_user.can_book?(expired_event)).to be(false)
        expect(admin_user.can_see_availability?).to be(true)
      end
    end
  end
end
