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
end
