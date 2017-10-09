# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'default user' do
    subject { FactoryGirl.create :user }

    it { should respond_to(:email) }
    it { should respond_to(:encrypted_password) }
    it { should respond_to(:role) }
    it { should respond_to(:status) }

    it 'has default role' do
      expect(subject.role).to eq('fan')
    end
    it 'has default status' do
      expect(subject.status).to eq('pending')
    end
  end
  context 'admin user' do
    let(:fan_user) { FactoryGirl.create(:user, role: 'fan') }
    let(:admin_user) { FactoryGirl.create(:user, role: 'admin') }
    let(:fan1) { FactoryGirl.create(:fan, user: fan_user) }
    let(:fan2) { FactoryGirl.create(:fan, user: admin_user) }

    subject { admin_user }

    it 'admin?' do
      expect(subject.admin?).to be(true)
    end

    it 'can see all fans' do
      expect(subject.allowed_fans).to match_array([fan1, fan2])
    end
  end

  context 'fan user' do
    let(:fan_user) { FactoryGirl.create(:user, role: 'fan') }
    let(:admin_user) { FactoryGirl.create(:user, role: 'admin') }
    let(:fan1) { FactoryGirl.create(:fan, user: fan_user) }
    let(:fan2) { FactoryGirl.create(:fan, user: admin_user) }

    subject { fan_user }

    it 'admin?' do
      expect(subject.admin?).to be(false)
    end

    it 'can see all fans' do
      expect(subject.allowed_fans).to match_array([fan1])
    end
  end
end
