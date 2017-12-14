# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    DatabaseCleaner.clean_with(:truncation)
  end

  context 'default user' do
    subject { FactoryGirl.build :user }

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
end
