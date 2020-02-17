# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DecoratorHelper do
  let(:decorator_instance) { DecoratorHelper.new }
  describe '.users' do
    it 'serializes as expected' do
      host 'www.example.com'
      user = FactoryGirl.create(:user)

      expect(decorator_instance.users(user)).to eq([])
    end
  end
end
