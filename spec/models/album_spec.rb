# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Album, type: :model do
  context 'default album' do
    subject { FactoryGirl.build :album }

    it { should respond_to(:title) }
    it { should respond_to(:url) }
    it { should respond_to(:event_id) }
  end
end
