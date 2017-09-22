# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fan, type: :model do
  let(:user) { FactoryGirl.create :user }
  let!(:fan1) { FactoryGirl.create :fan, user: user }
  let!(:fan2) { FactoryGirl.create :fan, user: user }

  context 'default fan' do
    subject { fan1 }

    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:date_of_birth) }
    it { should respond_to(:place_of_birth) }
    it { should respond_to(:fidelity_card_no) }

    it 'belongs to a user' do
      expect(subject.user).to eq(user)
    end

    it 'has a many to one relationship with user' do
      expect(user.fans).to match_array([subject, fan2])
    end
  end
end
