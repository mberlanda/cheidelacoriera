# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DecoratorHelper do
  let(:decorator_instance) { DecoratorHelper.new }
  describe '.users' do
    it 'serializes as expected' do
      user = FactoryBot.create(:user)

      expect(decorator_instance.users(user)).to eq(
        [
          "<a href=\"/admin/users/#{user.id}\">#{user.email}</a>",
          user.first_name,
          user.last_name,
          '<div class="status-pending">pending</div>',
          "<div class=\"role-#{user.email}\">#{user.email}</div>",
          user.phone_number,
          '<div class="bool-true">true</div>',
          '<div class="bool-false">false</div>',
          nil
        ]
      )
    end
  end
end
